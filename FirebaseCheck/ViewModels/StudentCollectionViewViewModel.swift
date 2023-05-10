//
//  StudentCollectionViewViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 29.03.2023.
//

import Foundation

class StudentCollectionViewViewModel: StudentCollectionViewViewModelType {
    
    var student: [StudentInfo] = []
    var getDictByStatus: [String: Int] = [:]
    static var numberOfTokens: Int = 0
    
    func queryLessons(name: String, surname: String, code: String, day: String, month: String, year: String, completion: @escaping () -> Void) {
        
        student = []
        getDictByStatus = [:]
        let todaysDay = "\(day).\(month).\(year)"
        
        let getData =  DatabaseManager.shared.database.collection("subjects").whereField("teacherID", isEqualTo: "\(name.lowercased()).\(surname.lowercased())")
            .whereField("code", isEqualTo: code)
        
        getData.getDocuments { (data, error) in
            if error != nil {return}
            
            guard let data = data?.documents else {
                return
            }
            
            let getStudentsStatus = DatabaseManager.shared.database.collection("attendance").whereField("code", isEqualTo: code)
            
            getStudentsStatus.getDocuments { data, error in
                if error != nil { return }
                guard let data = data, error == nil else { return }
                for status in data.documents {
                    let keys = status.data().keys
                    for key in keys {
                        if key == todaysDay {
                            let value = status.data()[key]
                            if let arr = value as? [Any] {
                                if let dict = arr[0] as? [String: Any] {
                                    for key in dict.keys {
                                        var sum = 0
                                        for k in dict[key] as! [Int] {
                                            sum += k
                                        }
                                        self.getDictByStatus[key] = sum
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            for sub in data {
                let subject: String = sub.documentID
                let subjectRef = DatabaseManager.shared.database.collection("subjects").document(subject)
                
                subjectRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let dates = document.get("dates") as! [String]
                        let enrolledStudents = document.get("enrolledStudents") as! [String]
                        let startTime = document.get("startTime") as! String
                        let endTime = document.get("endTime") as! String
                        
                        if self.subCodeString(str: startTime) != self.subCodeString(str: endTime) {
                            StudentCollectionViewViewModel.numberOfTokens = 1
                        }
        
                        if dates.contains(todaysDay) {
                            for student in enrolledStudents {
                                let getStudents = DatabaseManager.shared.database.collection("students")
                                    .whereField("id", isEqualTo: student)
                                
                                getStudents.getDocuments { (data, error) in
                                    guard let data = data?.documents else {
                                        return
                                    }
                                    
                                    for data in data {
                                        let key = self.getDictByStatus[student] ?? 0
                                        let name = data.get("name") as! String
                                        let surname = data.get("surname") as! String
                                        self.student.append(StudentInfo(name: name, surname: surname, status: false, attCount: key, id: student))
                                    }
                                    completion()
                                }
                            }
                        }
                    } else {
                        print("Subject document does not exist")
                    }
                }
            }
        }
    }
    
    func numberOfRows() -> Int {
        return student.count
    }
    
    func cellViewModel(for indexPath: IndexPath) -> StudentCollectionViewCellViewModelType? {
        var student = student[indexPath.row]
        if StudentViewController.statusDelegate == true {
            student.status = true
        }else {
            student.status = false
        }
        return StudentCollectionViewCellViewModel(student: student)
    }
}

extension StudentCollectionViewViewModel {
    func subCodeString(str: String) -> String {
        let startIndex = str.index(str.startIndex, offsetBy: 0)
        let endIndex = str.index(str.startIndex, offsetBy: 1)
        let range = startIndex...endIndex
        let substring = String(str[range])
        return String(substring)
    }
}
