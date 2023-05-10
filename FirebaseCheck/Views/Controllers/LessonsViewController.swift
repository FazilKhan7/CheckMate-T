//
//  LessonsViewController.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 24.03.2023.
//

import Foundation
import UIKit

class LessonsViewController: UIViewController {
    
    private var lessonsViewModel: LessonsViewModelType?
    
    let calendarView = UICalendarView(frame: CGRect.zero)
    let delegateStr = HomeViewController.delegateStr
    
    static var subjectCode: String = ""
    static var selectedDay: String = ""
    static var selectedMonth: String = ""
    static var selectedYear: String = ""
    
    let myClassesLabel = makeLabel(fontSize: 20, color: #colorLiteral(red: 0, green: 0.1445877552, blue: 0.4285367131, alpha: 1), weight: .medium)
    let noClassesLabel = makeLabel(fontSize: 19, color: .systemGray2, weight: .medium, text: "There is no classes for this date.")
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let sectionInsets = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.backward"), for: .normal)
        backButton.setTitle("Back", for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector(backAction), for: .primaryActionTriggered)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let textAttributes = [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0, green: 0.1445877552, blue: 0.4285367131, alpha: 1)]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        setup()
        todaysData()
        addAllSubViews()
        layout()
        layoutCalendarView()
    }
    
    private func todaysData() {
        let date = NSDate()
        let calendar = NSCalendar.current
        let components = calendar.dateComponents(in: .current, from: date as Date)
        var day: String = String(components.day!)
        var month: String = String(components.month!)
        let monthName = DateFormatter().monthSymbols[Int(month)! - 1]
        let year: String = String(components.year!)
                
        if month.count == 1 { month = "0\(month)" }
        if day.count == 1 { day = "0\(day)" }
        
        let lessonsCollectionViewViewModel = LessonsCollectionViewViewModel()
        
        let accountInfoViewModel = AccountInfoViewModel(
            student: Student(name: UserDefaults.standard.value(forKey: "name") as? String ?? "",
                             surname: UserDefaults.standard.value(forKey: "surname") as? String ?? "",
                             email: UserDefaults.standard.value(forKey: "email") as? String ?? "")
        )
        
        myClassesLabel.text = "\(day)th \(monthName), \(year)"
        
        lessonsViewModel = LessonsViewModel(lessonsCollectionViewViewModel: lessonsCollectionViewViewModel)
        
        if lessonsViewModel?.lessonsCollectionViewViewModel?.numberOfRows() == 0 {
            self.noClassesLabel.isHidden = false
        }else {
            self.noClassesLabel.isHidden = true
        }
        
        lessonsViewModel?.lessonsCollectionViewViewModel?.queryLessons(name: accountInfoViewModel.student.name.lowercased(), surname: accountInfoViewModel.student.surname.lowercased(), code: delegateStr, day: day, month: month, year: year, completion: { [weak self] in
            self?.collectionView.reloadData()
        })
    }
    
    @objc private func backAction() {
        dismiss(animated: true)
    }
    
    private func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .secondarySystemBackground
        collectionView.register(LessonsCell.self, forCellWithReuseIdentifier: LessonsCell.lessonReuseID)
        
        noClassesLabel.numberOfLines = 0
        noClassesLabel.textAlignment = .center
        
        let db = DB()
        
        db.attendanceCourseStudentIDValue()
        
        testQuery()
    }
    
    private func layoutCalendarView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        myClassesLabel.isUserInteractionEnabled = true
        calendarView.isHidden = true
        myClassesLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc func labelTapped() {
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        calendarView.delegate = self
        calendarView.isHidden = !calendarView.isHidden
        calendarView.layer.borderWidth = 1
        calendarView.layer.cornerRadius = 8
        calendarView.layer.borderColor = UIColor.systemBackground.cgColor
        calendarView.backgroundColor = UIColor.systemBackground
        
        let selection = UICalendarSelectionSingleDate(delegate: self)
        calendarView.selectionBehavior = selection
        view.addSubview(calendarView)
        
        NSLayoutConstraint.activate([
            calendarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            calendarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            calendarView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    
    private func addAllSubViews() {
        view.addSubview(myClassesLabel)
        view.addSubview(collectionView)
        view.addSubview(noClassesLabel)
    }
    
    private func layout() {
        
        NSLayoutConstraint.activate([
            myClassesLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            myClassesLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            noClassesLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            noClassesLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: myClassesLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension LessonsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let itemsPerRow: CGFloat = 1
        let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
    }
}

extension LessonsViewController: UICollectionViewDelegate {
    
}

extension LessonsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lessonsViewModel?.lessonsCollectionViewViewModel?.numberOfRows() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LessonsCell.lessonReuseID, for: indexPath) as! LessonsCell
        
        let cellViewModel = lessonsViewModel?.lessonsCollectionViewViewModel?.cellViewModel(for: indexPath)
        
        navigationItem.title = cellViewModel?.titleCode
        myClassesLabel.text = cellViewModel?.todaysDay
        cell.viewModel = cellViewModel
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cellViewModel = lessonsViewModel?.lessonsCollectionViewViewModel?.cellViewModel(for: indexPath)
        
        let name: String = cellViewModel?.titleCode ?? ""
        let code: String = cellViewModel?.subjectCode ?? ""
        
        let trimmedStr = name.replacingOccurrences(of: " ", with: "") + "" + code
        
        LessonsViewController.subjectCode = trimmedStr
        
        let vc = StudentViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension LessonsViewController: UICalendarViewDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        return nil
    }
}

extension LessonsViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
        var day: String = String((dateComponents?.day)!)
        var month: String = String((dateComponents?.month)!)
        let year: String = String((dateComponents?.year)!)
        let monthName = DateFormatter().monthSymbols[Int(month)! - 1]
        
        if month.count == 1 { month = "0\(month)" }
        if day.count == 1 { day = "0\(day)" }
        
        myClassesLabel.text = "\(day)th \(monthName), \(year)"
        LessonsViewController.selectedDay = day
        LessonsViewController.selectedMonth = month
        LessonsViewController.selectedYear = year
        
        let accountInfoViewModel = AccountInfoViewModel(
            student: Student(name: UserDefaults.standard.value(forKey: "name") as? String ?? "",
                             surname: UserDefaults.standard.value(forKey: "surname") as? String ?? "",
                             email: UserDefaults.standard.value(forKey: "email") as? String ?? "")
        )
        
        lessonsViewModel?.lessonsCollectionViewViewModel?.queryLessons(name: accountInfoViewModel.student.name.lowercased(), surname: accountInfoViewModel.student.surname.lowercased(), code: delegateStr, day: day, month: month, year: year, completion: { [weak self] in
            self?.collectionView.reloadData()
            
            if self?.lessonsViewModel?.lessonsCollectionViewViewModel?.numberOfRows() == 0 {
                self?.noClassesLabel.isHidden = false
            }else {
                self?.noClassesLabel.isHidden = true
            }
            
            self?.calendarView.isHidden = true
        })
    }
}
