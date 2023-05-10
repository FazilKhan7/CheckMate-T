//
//  TestDatabase.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 18.03.2023.
//

import Foundation


// Step 1: Query the subject ID
let subjectQuery = DatabaseManager.shared.database.collection("subjects").whereField("code", isEqualTo: "CSS342[01-N]")


class DB {
    func attendanceCourseStudentIDValue() {
        //Setting CSS358[01-N]
//        let data1 = [
//            "15.05.2023" : [
//                ["200107116": "0/1"],
//                ["200107055": "0/1"],
//                ["200107085": "0/1"],
//                ["200107094": "0/1"],
//                ["200107092": "0/1"],
//                ["200107038": "0/1"],
//                ["200107044": "0/1"],
//                ["200107005": "0/1"],
//                ["200107027": "0/1"],
//            ]
//        ]
//        let ref = DatabaseManager.shared.database.collection("attendance").document("CSS358[01-N]").setData(data1, merge: true)
//
        
        //CSS342[07-P]
        
//        let data2 = [
//                    "16.05.2023" : [
//                        ["200107116": "0/1"],
//                        ["200107055": "0/1"],
//                        ["200107085": "0/1"],
//                        ["200107094": "0/1"],
//                        ["200107092": "0/1"],
//                        ["200107038": "0/1"],
//                        ["200107044": "0/1"],
//                        ["200107005": "0/1"],
//                        ["200107027": "0/1"],
//                    ]
//                ]
//        let ref = DatabaseManager.shared.database.collection("attendance").document("CSS342[07-P]").setData(data2, merge: true)
    }
}

func testQuery() {
//    subjectQuery.getDocuments() { (subjectSnapshot, error) in
//        if let error = error {
//            return
//        }
//        guard let subjectDoc = subjectSnapshot?.documents.first else {
//            return
//        }
//
//        let subjectID = subjectDoc.documentID
//
//        // Step 2: Query the EnrolledStudents subcollection
//        let enrolledStudentsQuery = DatabaseManager.shared.database.collection("subjects/\(subjectID)/enrollments")
//        enrolledStudentsQuery.getDocuments() { (enrolledStudentsSnapshot, error) in
//            if error != nil {
//                return
//            }
//
//            // Step 3: For each document in the EnrolledStudents subcollection, query the attendance field for the specified date
//            for enrolledStudentDoc in enrolledStudentsSnapshot!.documents {
//                let studentID = enrolledStudentDoc.documentID
//
//                let attendance = enrolledStudentDoc.get("attendance") as? [String:Any]
//                if let attendance = attendance {
//                    if let recordDate = attendance["date"] as? String, recordDate == "10.04.2023",
//                       let status = attendance["status"] as? String {
//                        print("Student \(studentID) attended on 15.03.2023 with status: \(status)")
//                    }
//                }
//
//            }
//        }
//    }
    
    
//    let date = NSDate()
//    let calendar = NSCalendar.current
//    let components = calendar.dateComponents(in: .current, from: date as Date)
//    let day: String = String(components.day!)
//    var month: String = String(components.month!)
//    let year: String = String(components.year!)
//    
//    if month.count == 1 {
//        month = "0\(month)"
//    }
//    
//    let todaysDay: String = "\(day).\(month).\(year)"
//    
//    let getData =  DatabaseManager.shared.database.collection("subjects").whereField("teacherID", isEqualTo: "alexandr.ivanov")
//
//    getData.getDocuments { (data, error) in
//        if error != nil {return}
//
//        guard let data = data?.documents else {
//            return
//        }
//
//        for sub in data {
//            let subject: String = sub.documentID
//            let subjectRef = DatabaseManager.shared.database.collection("subjects").document(subject)
//            
//            subjectRef.getDocument { (document, error) in
//                if let document = document, document.exists {
//                    let dates = document.get("dates") as! [String]
//                    if dates.contains(todaysDay) {
//                        print(subject + "Subject")
//                    }
//                } else {
//                    print("Subject document does not exist")
//                }
//            }
//        }
//    }
}
