//
//  AbsenceDatesViewController.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 09.05.2023.
//

import Foundation
import UIKit


class AbsenceDatesViewController: UIViewController {
    
    private var absenceViewModel: AbsenceViewModelType?
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let absenceCollectionViewViewModel = AbsenceCollectionViewViewModel()
        
        absenceViewModel = AbsenceViewModel(absenceCollectionViewViewModel: absenceCollectionViewViewModel)
        
        if let storedDict = userDefaults.object(forKey: "myDictKey") as? [String: String] {
            if let value1 = storedDict["code"], let value2 = storedDict["id"] {
                
                let docId = DatabaseManager.shared.database.collection("subjects").whereField("name", isEqualTo: value1)
                
                docId.getDocuments { data, error in
                    guard let data = data, error == nil else {return}
                    
                    for dd in data.documents {
                        let str: String = String(dd.documentID.prefix(6))
                        self.absenceViewModel?.absenceCollectionViewViewModel?.queryLessons(code: str, id: value2 ,completion: {
                            self.collectionView.reloadData()
                        })
                        break
                    }
                }
            }
        }
        
        setupCollectionView()
        addAllSubviews()
        setup()
        layout()
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
        collectionView.register(AbsenceCell.self, forCellWithReuseIdentifier: AbsenceCell.absenceCell)
    }
    
    private func addAllSubviews() {
        view.addSubview(collectionView)
    }
    
    private func setup() {
        view.backgroundColor = #colorLiteral(red: 0.918249011, green: 0.9182489514, blue: 0.9182489514, alpha: 1)
        navigationItem.title = "Absences"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissTheScreen))
    }
    
    @objc private func dismissTheScreen() {
        dismiss(animated: true)
    }
    
    private func layout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let sectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
}


extension AbsenceDatesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 1
        let paddingWidth = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}

extension AbsenceDatesViewController: UICollectionViewDelegate {
    
}

extension AbsenceDatesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return absenceViewModel?.absenceCollectionViewViewModel?.numberOfRows() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AbsenceCell.absenceCell, for: indexPath) as! AbsenceCell
        
        let cellViewModel = absenceViewModel?.absenceCollectionViewViewModel?.cellViewModel(for: indexPath)
        
        cell.hour.text = cellViewModel?.hour
        cell.date.text = cellViewModel?.date
        
        return cell
    }
}
