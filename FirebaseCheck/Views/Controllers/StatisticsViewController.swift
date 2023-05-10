//
//  StatisticsViewController.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 06.05.2023.
//

import Foundation
import UIKit

class StatisticsViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    
    let titleLabel = makeLabel(fontSize: 20, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), weight: .medium, text: "Statistics")
    var searchBar: UISearchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = "200107055"
        search.barTintColor = #colorLiteral(red: 0.918249011, green: 0.9182489514, blue: 0.9182489514, alpha: 1)
        return search
    }()
    
    var studentAccountView = StudentAccountView()
    private var statisticsViewModel: StatisticsViewModelType?
    var searchedText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let statisticsCollectionViewViewModel = StatisticsCollectionViewViewModel()
        
        statisticsViewModel = StatisticsViewModel(statisticsCollectionViewViewModel: statisticsCollectionViewViewModel)
        
        addAllSubviews()
        setup()
        layout()
        setupCollectionView()
        addTapBarGestureRecognizer()
    }
    
    private func addTapBarGestureRecognizer() {
        let tapBarGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapBarGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = #colorLiteral(red: 0.918249011, green: 0.9182489514, blue: 0.9182489514, alpha: 1)
        collectionView.register(StatisticsCell.self, forCellWithReuseIdentifier: StatisticsCell.statisticsCell)
    }
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let sectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
    private func addAllSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(searchBar)
        view.addSubview(studentAccountView)
        view.addSubview(collectionView)
    }
    
    private func setup() {
        view.backgroundColor = #colorLiteral(red: 0.918249011, green: 0.9182489514, blue: 0.9182489514, alpha: 1)
        studentAccountView.translatesAutoresizingMaskIntoConstraints = false
        studentAccountView.isHidden = true
        searchBar.delegate = self
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            searchBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            studentAccountView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 10),
            studentAccountView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            studentAccountView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: studentAccountView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension StatisticsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        studentAccountView.isHidden = false
        
        let docId = DatabaseManager.shared.database.collection("students").whereField("id", isEqualTo: searchedText)
        
        docId.getDocuments { [self] data, error in
            guard let data = data, error == nil else { print("ERROR, User is not found"); return }
            
            if data.isEmpty {
                studentAccountView.updateLabels(n: "", e: "")
                statisticsViewModel?.statisticsCollectionViewViewModel?.queryLessons(id: searchedText, completion: { _ in
                    self.collectionView.reloadData()
                })
                studentAccountView.isHidden = true
            }else{
                for d in data.documents {
                    let name = d.get("name") as! String
                    let surname = d.get("surname") as! String
                    let email = d.get("email") as! String
                    self.studentAccountView.updateLabels(n: "\(name) \(surname)", e: email)
                }
                statisticsViewModel?.statisticsCollectionViewViewModel?.queryLessons(id: searchedText, completion: { _ in
                    self.collectionView.reloadData()
                })
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("Cancel button tapped")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedText = searchText
    }
}


extension StatisticsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 1
        let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 145)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}

extension StatisticsViewController: UICollectionViewDelegate {
    
}

extension StatisticsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statisticsViewModel?.statisticsCollectionViewViewModel?.numberOfRows() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticsCell.statisticsCell, for: indexPath) as! StatisticsCell
        
        let cellViewModel = statisticsViewModel?.statisticsCollectionViewViewModel?.cellViewModel(for: indexPath)
        
        let subName = cellViewModel?.subjectName
        let attendCount = cellViewModel?.presenceCount
        let absenceCount = cellViewModel?.absenceCount
        let totalHourss = cellViewModel?.totalAttendanceCount
        
        cell.viewDetailsButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .primaryActionTriggered)
        cell.subName.text = subName!
        cell.hoursLabel.text = "Hours"
        cell.hoursCount.text = String(totalHourss ?? 0)
        cell.attendCount.text = String(attendCount ?? 0)
        cell.absenceCount.text = String(absenceCount ?? 0)
        cell.pCount.text = "0"
        return cell
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? StatisticsCell,
              let _ = collectionView.indexPath(for: cell) else {
            return
        }
        
        var myDict = userDefaults.dictionary(forKey: "myDictKey") as? [String: String] ?? [String: String]()
        myDict["code"] = cell.subName.text!
        myDict["id"] = searchedText
        userDefaults.set(myDict, forKey: "myDictKey")
        
        let vc = AbsenceDatesViewController()
        let nv = UINavigationController(rootViewController: vc)
        present(nv, animated: true)
    }
}
