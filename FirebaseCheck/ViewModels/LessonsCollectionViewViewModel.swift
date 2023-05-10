//
//  LessonsCollectionViewViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 24.03.2023.



import Foundation

class LessonsCollectionViewViewModel: LessonsCollectionViewViewModelType {
    
    var lessons: [Lessons] = []
    
    func queryLessons(name: String, surname: String, code: String, day: String, month: String, year: String, completion: @escaping () -> Void) {
        lessons = []
        let todaysDay: String = "\(day).\(month).\(year)"
        
        let getData =  DatabaseManager.shared.database.collection("subjects").whereField("teacherID", isEqualTo: "\(name.lowercased()).\(surname.lowercased())")
            .whereField("name", isEqualTo: code)
        
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
                        let dates = document.get("dates") as! [String]
                        let startTime = document.get("startTime") as! String
                        let endTime = document.get("endTime") as! String
                        let name = document.get("name") as! String
                        let code = document.get("code") as! String
                        if dates.contains(todaysDay) {
                            self.lessons.append(Lessons(subjectCode: subject, subjectName: name, startTime: startTime, endTime: endTime, todaysDay: todaysDay, titleCode: code))
                        }
                    } else {
                        print("Subject document does not exist")
                    }
                    completion()
                }
            }
        }
    }
    
    func numberOfRows() -> Int {
        return lessons.count
    }
    
    func cellViewModel(for indexPath: IndexPath) -> LessonsCollectionViewCellViewModelType? {
        let lesson = lessons[indexPath.row]
        return LessonsCollectionViewCellViewModel(lessons: lesson)
    }
}

extension String {
    func subString(str: String) -> String {
        let startIndex = str.index(str.startIndex, offsetBy: 0)
        let endIndex = str.index(str.startIndex, offsetBy: 6)
        let range = startIndex...endIndex
        let substring = String(str[range])
        return String(substring)
    }
}
