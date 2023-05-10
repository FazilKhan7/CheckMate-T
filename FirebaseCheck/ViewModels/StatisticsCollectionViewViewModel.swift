//
//  StatisticsCollectionViewViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 08.05.2023.
//

import Foundation

class StatisticsCollectionViewViewModel: StatisticsCollectionViewViewModelType {
    
    var subjects: [StudentStatistics] = []
        
    func queryAmountOfClasses(subjectCode code: String, id: String, completion: @escaping (Int) -> ()) {
        
        let docID = DatabaseManager.shared.database.collection("students").whereField("id", isEqualTo: id)
        var totalAttendanceCount = 0
        var amountOfHours = 0
        docID.getDocuments {snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                return
            }
                    
            let ref = DatabaseManager.shared.database.collection("subjects")
                .whereField("code", isGreaterThan: "\(code)")
                .whereField("code", isLessThan: "\(code)u{f8ff}]")
            ref.getDocuments { snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    return
                }
                
                for doc in snapshot.documents {
                    let startTime = (doc.get("startTime") as? String ?? "")
                    let endTime = (doc.get("endTime") as? String ?? "")
                                        
                    let startHour = Int(String(startTime.prefix(2))) ?? 0
                    let endHour = Int(String(endTime.prefix(2))) ?? 0
                    
                    amountOfHours = endHour - startHour
                    if amountOfHours + 1 == 2 {
                        totalAttendanceCount += (((doc.get("dates") as? [String])?.count ?? 15) * 2)
                    } else {
                        totalAttendanceCount += ((doc.get("dates") as? [String])?.count ?? 15)
                    }
                }
                completion(totalAttendanceCount)
                totalAttendanceCount = 0
            }
        }
    }
    
    func queryLessons(id: String, completion: @escaping ([StudentStatistics]) -> Void) {
        
        subjects = []
        
        let docID = DatabaseManager.shared.database.collection("students").whereField("id", isEqualTo: id)
        let dispatchGroup = DispatchGroup()
        
        docID.getDocuments { snapshot, error in
            guard snapshot == snapshot, error == nil else {
                return
            }
                        
            DatabaseManager.shared.database.collection("subjects").whereField("enrolledStudents", arrayContains: id)
                .order(by: "id").getDocuments  { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    }else {
                        for document in querySnapshot!.documents {
                            let code = document.get("code") as? String ?? ""
                            let name = document.get("name") as? String ?? ""
                            
                            dispatchGroup.enter()
                            self.queryAmountOfClasses(subjectCode: String(code.prefix(6)), id: id, completion: { total in
                                self.queryAttendance(id: id, for: String(code.prefix(6)), completion: { presenceCount, absenceCount in
                                    let contains = self.checkIfContains(subjects: self.subjects,name: name)
                                    
                                    if !contains {
                                        self.subjects.append(StudentStatistics(subjectCode: code, subjectName: name, totalAttendanceCount: total, presenceCount: presenceCount, absenceCount: absenceCount, id: id))
                                        print(self.subjects)
                                        self.subjects.sort(by: { s1, s2 in
                                            s1.subjectCode < s2.subjectCode
                                        })
                                    }
                                    dispatchGroup.leave()
                                })
                            })
                        }
                        dispatchGroup.notify(queue: .main) {
                            completion(self.subjects)
                        }
                    }
                }
            }
    }
    
    func queryAttendance(id: String, for subject: String, completion: @escaping (_ presenceCount: Int, _ absenceCount: Int) -> Void) {
        
        let docID = DatabaseManager.shared.database.collection("students")
            .whereField("id", isEqualTo: id)
        var presenceCount = 0
        var absenceCount = 0
        
        docID
            .getDocuments { snapshot, error in
                guard snapshot == snapshot, error == nil else {
                    return
                }
                
                DatabaseManager.shared.database.collection("attendance")
                    .whereField("code", isGreaterThanOrEqualTo: subject)
                    .whereField("code", isLessThan: "\(subject)u{f8ff}]")
                    .getDocuments { snapshot, error in
                        guard let snapshot = snapshot, error == nil else {
                            return
                        }
                        
                        for document in snapshot.documents {
                            let dates = document.data().keys //dates 15.03.2023...
                            for key in dates {
                                let value = document.data()[key]
                                if let arr = value as? [Any]{
                                    if let dict = arr[0] as? [String: Any] {
                                        guard let attendances = dict["\(id)"] as? [Int] else { continue }
                                        for attendance in attendances {
                                            if(attendance == 0) {
                                                absenceCount += 1;
                                            } else {
                                                presenceCount += 1
                                            }
                                        }
                                        
                                    }
                                } 
                            }
                        }
                        completion(presenceCount, absenceCount)
                    }
            }
    }
    
    
    func checkIfContains(subjects: [StudentStatistics], name: String) -> Bool {
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
    
    func cellViewModel(for indexPath: IndexPath) -> StatisticsCollectionViewCellViewModelType? {
        let statistics = subjects[indexPath.row]
        return StatisticsCollectionViewCellViewModel(statistics: statistics)
    }
}
