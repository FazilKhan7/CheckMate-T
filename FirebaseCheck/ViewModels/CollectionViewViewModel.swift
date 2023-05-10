//
//  CollectionViewViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 18.03.2023.
//

import Foundation

class CollectionViewViewModel: CollectionViewViewModelType {
    
    var subjects: [Subject] = []
    
    func querySubjects(name: String, surname: String, completion: @escaping () -> Void) {
        let docID = DatabaseManager.shared.database.collection("teachers").document("\(name) \(surname)")
        
        docID.getDocument { [weak self] snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }
            
            guard let teacherID = snapshot.get("id") else { return }
            
            let subjectRef = DatabaseManager.shared.database.collection("subjects")
            
            let querySubject = subjectRef.whereField("teacherID", isEqualTo: teacherID)
            
            querySubject.getDocuments {[self] snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    return
                }
                
                for document in snapshot.documents {
                    let code = document.get("code") as? String ?? ""
                    let name = document.get("name") as? String ?? ""
                    
                    guard let contains = self?.checkIfContains(name: name) else { return }
                    
                    if !contains {
                        self?.subjects.append(Subject(subjectCode: code, subjectName: name))
                    }
                                        
                }
                completion()
            }
        }
    }
    
    func checkIfContains(name: String) -> Bool {
        var contains = false
        
        for i in 0..<subjects.count {
            if subjects[i].subjectName == name {
                contains = true
            }
        }
        
        return contains
    }
    
    func numberOfRows() -> Int {
        return subjects.count
    }
    
    func cellViewModel(for indexPath: IndexPath) -> CollectionViewCellViewModelType? {
        let subject = subjects[indexPath.row]
        
        return CollectionViewCellViewModel(subject: subject)
    }
}
