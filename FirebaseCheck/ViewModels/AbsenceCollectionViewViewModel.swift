//
//  AbsenceCollectionViewViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 09.05.2023.
//

import Foundation

class AbsenceCollectionViewViewModel: AbsenceCollectionViewViewModelType {
    
    var absences: [Absence] = []
    func getDates(shortSubjectCode: String, id: String, completion: @escaping ([String]?, [String]?) -> Void) {
        
        var dates: [String] = []
        var times: [String] = []
        let docRef = DatabaseManager.shared.database.collection("subjects")
            .whereField("code", isGreaterThanOrEqualTo: shortSubjectCode)
            .whereField("code", isLessThan: "\(shortSubjectCode)u{f8ff}]")
            .whereField("enrolledStudents", arrayContains: id)
        
        docRef.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("Error when fetching dates")
                completion(nil, nil)
                return
            }
                        
            for doc in snapshot.documents {
                if let data = doc.data()["dates"] as? [String], let startTime = doc.data()["startTime"] as? String{
                    for date in data {
                        dates.append(date)
                        times.append(startTime)
                    }
                }
            }
            completion(dates, times)
        }
    }
    
    func queryLessons(code: String, id: String, completion: @escaping () -> Void) {
        
        absences = []
        let docRef = DatabaseManager.shared.database.collection("attendance")
            .whereField("code", isGreaterThanOrEqualTo: code)
            .whereField("code", isLessThan: "\(code)u{f8ff}]")
                
        getDates(shortSubjectCode: code, id: id) { dates, time in
            guard let dates = dates else {
                completion()
                return
            }
            
            docRef.getDocuments { [self] snapshot, error in
                guard let snapshot = snapshot, error == nil else {
                    completion()
                    return
                }
                                
                for doc in snapshot.documents {
                    let data = doc.data()
                    for date in dates {
                        if let dateInfo = data[date] as? [[String: [Int]]] {
                            if let statuses = dateInfo[0][id] {
                                var counter = 0
                                for status in statuses {
                                    if status == 0 {
                                        if counter > 0 {
                                            let startHour = (Int((data["startTime"] as? String ?? ":").prefix(2)) ?? 0) + 1
                                            let time = String(startHour) + ":00"
                                            absences.append(Absence(date: date, hour: time))
                                        } else {
                                            absences.append(Absence(date: date, hour: data["startTime"] as? String ?? ":"))
                                        }
                                    }
                                    counter += 1
                                }
                            }
                        }
                    }
                }
                completion()
            }
        }
    }
    
    func numberOfRows() -> Int {
        return absences.count
    }
    
    func cellViewModel(for indexPath: IndexPath) -> AbsenceCollectionViewCellViewModelType? {
        let absence = absences[indexPath.row]
        return AbsenceCollectionViewCellViewModel(absence: absence)
    }
}
