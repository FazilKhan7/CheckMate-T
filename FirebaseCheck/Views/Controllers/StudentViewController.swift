//
//  StudentViewController.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 29.03.2023.
//

import Foundation
import UIKit

class StudentViewController: UIViewController {
    
    let studentList = makeLabel(fontSize: 20, color: #colorLiteral(red: 0, green: 0.1445877552, blue: 0.4285367131, alpha: 1), weight: .bold)
    let tokenCode = makeLabel(fontSize: 20, weight: .thin, text: "show code")
    var myView: UIView?
    var token1 = makeLabel(fontSize: 15, weight: .medium, text: "")
    var token2 = makeLabel(fontSize: 15, weight: .medium, text: "")
    let stackView = makeStackView(axis: .vertical, spacing: 10)
    var isViewHidden = false
    
    private let refreshControl = UIRefreshControl()
    
    let attendanceButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let edit = UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 29))
        button.setImage(edit, for: .normal)
        return button
    }()
    
    private var studentViewModel: StudentViewModelType?
    static var statusDelegate: Bool = false
    static var refreshController: Bool = false
    let codeName = LessonsViewController.subjectCode
    var selectedDay = LessonsViewController.selectedDay
    var selectedMonth = LessonsViewController.selectedMonth
    var selectedYear = LessonsViewController.selectedYear
    
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    
    let sectionInsets = UIEdgeInsets(top: 8, left: 11, bottom: 8, right: 11)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: attendanceButton)
        studentList.text = "Student List"
        
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        
        attendanceButton.addTarget(self, action: #selector(appearAttendanceButton), for: .primaryActionTriggered)
        
        todaysDay()
        setup()
        addAllSubViews()
        layout()
        addTapGesture( )
    }
    
    private func addTapGesture() {
        tokenCode.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        tokenCode.addGestureRecognizer(tapGesture)
    }
    
    @objc func labelTapped() {
        
        if isViewHidden {
            UIView.animate(withDuration: 0.3, animations: {
                self.myView?.frame.origin.y = self.view.frame.maxY
            }) { _ in
                self.myView?.removeFromSuperview()
                self.myView = nil
            }
        } else {
            myView = UIView(frame: CGRect(x: (view.frame.width - 200) / 2, y: view.frame.maxY, width: 200, height: 200))
            myView?.layer.borderWidth = 1
            myView?.backgroundColor = .systemBackground
            myView?.layer.cornerRadius = 10
            myView?.layer.borderColor = UIColor.systemGray3.cgColor
            myView?.addSubview(stackView)
            stackView.centerXAnchor.constraint(equalTo: myView!.centerXAnchor).isActive = true
            stackView.centerYAnchor.constraint(equalTo: myView!.centerYAnchor).isActive = true
            view.addSubview(myView!)
            
            UIView.animate(withDuration: 0.3) {
                self.myView?.frame.origin.y = (self.view.frame.height - self.myView!.frame.height) / 2
            }
        }
        isViewHidden.toggle()
    }
        
        @objc private func refreshData(_ sender: Any) {
            StudentViewController.refreshController = true
            StudentViewController.statusDelegate = true
            
            let accountInfoViewModel = AccountInfoViewModel(
                student: Student(name: UserDefaults.standard.value(forKey: "name") as? String ?? "",
                                 surname: UserDefaults.standard.value(forKey: "surname") as? String ?? "",
                                 email: UserDefaults.standard.value(forKey: "email") as? String ?? "")
            )
            
            studentViewModel?.studentCollectionViewViewModel?.queryLessons(name: accountInfoViewModel.student.name.lowercased(), surname: accountInfoViewModel.student.surname.lowercased(), code: codeName, day: selectedDay, month: selectedMonth, year: selectedYear, completion: {
                [weak self] in
                self?.collectionView.reloadData()
            })
            
            collectionView.reloadData()
            refreshControl.endRefreshing()
            
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            if StudentViewController.refreshController == true {
                StudentViewController.refreshController = true
            }else{
                StudentViewController.statusDelegate = false
            }
        }
        
        @objc func appearAttendanceButton() {
            StudentViewController.statusDelegate = true
            addStudents()
            addTokens()
            collectionView.reloadData()
        }
        
        func addStudents() {
            
            let selectedDay = "\(selectedDay).\(selectedMonth).\(selectedYear)"
            var dd: [String: [Bool]] = [:]
            
            let accountInfoViewModel = AccountInfoViewModel(
                student: Student(name: UserDefaults.standard.value(forKey: "name") as? String ?? "",
                                 surname: UserDefaults.standard.value(forKey: "surname") as? String ?? "",
                                 email: UserDefaults.standard.value(forKey: "email") as? String ?? "")
            )
            
            let getData =  DatabaseManager.shared.database.collection("subjects").whereField("teacherID", isEqualTo: "\(accountInfoViewModel.student.name.lowercased()).\(accountInfoViewModel.student.surname.lowercased())")
                .whereField("code", isEqualTo: codeName)
            
            getData.getDocuments { (data, error) in
                if error != nil {return}
                
                guard let data = data?.documents else {
                    return
                }
                
                for sub in data {
                    let subject: String = sub.documentID
                    let subjectRef = DatabaseManager.shared.database.collection("subjects").document(subject)
                    
                    subjectRef.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let enrolledStudents = document.get("enrolledStudents") as! [String]
                            let startTime = document.get("startTime") as! String
                            DatabaseManager.shared.database.collection("attendance").document(self.codeName).setData(["startTime": startTime], merge: true)
                            if StudentCollectionViewViewModel.numberOfTokens == 1 {
                                for id in enrolledStudents {
                                    dd[id] = [false, false]
                                }
                            }else{
                                for id in enrolledStudents {
                                    dd[id] = [false]
                                }
                            }
                        }
                        let attendanceData: [String: [[String: [Bool]]]] = [selectedDay: [dd]]
                        DatabaseManager.shared.database.collection("attendance").document(self.codeName).setData(attendanceData, merge: true)
                    }
                }
            }
        }
        
        func addTokens() {
            
            let selectedDay = "\(selectedDay).\(selectedMonth).\(selectedYear)"
            
            func generateRandomString() -> String {
                let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
                let randomString = String((0..<6).map{ _ in letters.randomElement()! })
                return randomString
            }
            
            let t1 = generateRandomString()
            let t2 = generateRandomString()
            
            if StudentCollectionViewViewModel.numberOfTokens == 1 {
                token1.text = t1
                token2.text = t2
            }else{
                token1.text = t1
                token2.isHidden = true
            }
            
            
            let tokens = [
                "tokens": [selectedDay: [t1, t2]]
            ]
            
            DatabaseManager.shared.database.collection("attendance").document(codeName).setData(tokens, merge: true)
        }
        
        private func todaysDay() {
            
            let date = NSDate()
            let calendar = NSCalendar.current
            let components = calendar.dateComponents(in: .current, from: date as Date)
            var day: String = String(components.day!)
            var month: String = String(components.month!)
            let year: String = String(components.year!)
            
            if month.count == 1 { month = "0\(month)" }
            if day.count == 1 { day = "0\(day)" }
            if selectedMonth.count == 1 { selectedMonth = "0\(selectedMonth)" }
            if selectedDay.count == 1 { selectedDay = "0\(selectedDay)" }
            
            if selectedDay == "" && selectedMonth == "" && selectedYear == "" {
                selectedDay = day
                selectedMonth = month
                selectedYear = year
            }
            
            let studentCollectionViewViewModel = StudentCollectionViewViewModel()
            
            studentViewModel = StudentViewModel(studentCollectionViewViewModel: studentCollectionViewViewModel)
            
            let accountInfoViewModel = AccountInfoViewModel(
                student: Student(name: UserDefaults.standard.value(forKey: "name") as? String ?? "",
                                 surname: UserDefaults.standard.value(forKey: "surname") as? String ?? "",
                                 email: UserDefaults.standard.value(forKey: "email") as? String ?? "")
            )
            
            studentViewModel?.studentCollectionViewViewModel?.queryLessons(name: accountInfoViewModel.student.name.lowercased(), surname: accountInfoViewModel.student.surname.lowercased(), code: codeName, day: selectedDay, month: selectedMonth, year: selectedYear, completion: {
                [weak self] in
                self?.collectionView.reloadData()
            })
        }
        
        @objc private func backAction() {
            let homeVC = LessonsViewController()
            homeVC.modalPresentationStyle = .fullScreen
            homeVC.modalTransitionStyle = .coverVertical
            present(homeVC, animated: true)
        }
        
        private func setup() {
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.backgroundColor = .secondarySystemBackground
            collectionView.register(StudentCell.self, forCellWithReuseIdentifier: StudentCell.studentCell)
            
            let db = DB()
            db.attendanceCourseStudentIDValue()
            testQuery()
        }
        
        private func addAllSubViews() {
            stackView.addArrangedSubview(token1)
            stackView.addArrangedSubview(token2)
            view.addSubview(studentList)
            view.addSubview(tokenCode)
            view.addSubview(attendanceButton)
            view.addSubview(collectionView)
        }
        
        private func layout() {
            
            NSLayoutConstraint.activate([
                studentList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
                studentList.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
            ])
            
            NSLayoutConstraint.activate([
                tokenCode.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
                tokenCode.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
            ])
            
            
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: studentList.bottomAnchor,constant: 12),
                collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 11),
                collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -11),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    }
    
    
    extension StudentViewController: UICollectionViewDelegateFlowLayout {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let itemsPerRow: CGFloat = 1
            let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
            let availableWidth = collectionView.frame.width - paddingWidth
            let widthPerItem = availableWidth / itemsPerRow
            return CGSize(width: widthPerItem, height: 80)
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 8, left: 11, bottom: 8, right: 11)
        }
    }
    
    extension StudentViewController: UICollectionViewDelegate {
        
    }
    
    extension StudentViewController: UICollectionViewDataSource {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return studentViewModel?.studentCollectionViewViewModel?.numberOfRows() ?? 0
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudentCell.studentCell, for: indexPath) as! StudentCell
            
            let cellViewModel = studentViewModel?.studentCollectionViewViewModel?.cellViewModel(for: indexPath)
                        
            cell.viewModel = cellViewModel
            cell.indexOfName.text = "\(indexPath.row + 1)."
            let name = cellViewModel?.name
            let surname = cellViewModel?.surname
            cell.nameAndSurname.text = "\(name!) \(surname!)"
                    
            return cell
        }
    }
