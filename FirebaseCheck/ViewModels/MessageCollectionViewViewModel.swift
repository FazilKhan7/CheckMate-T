//
//  MessageCollectionViewViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 26.04.2023.
//

import Foundation

class MessageCollectionViewViewModel: MessageCollectionViewViewModelType {
    
    var message: [ReasonMessage] = []
    
    func queryLessons(code: String, completion: @escaping () -> Void) {
        
        message = []
        let getMessageByStudents = DatabaseManager.shared.database.collection("message")
        
        getMessageByStudents.getDocuments { (data, error) in
            if error != nil {return}
            
            guard let data = data?.documents else {
                return
            }
            
            for snap in data {
                for d in snap.data() {
                    let value = d.value as! [String: Any]
                    let sender = value["sender"] as! String
                    let classTime = value["classTime"] as! String
                    let message = value["message"] as! String
                    let sentDate = value["sentDate"] as! String
                    let sentTime = value["sentTime"] as! String
                    let subject = value["subject"] as! String
                    let teacher =  value["to"] as! String
                    let classDate = value["classDate"] as! String
                    if teacher == code {
                        self.message.append(ReasonMessage(subCode: subject, sendTime: sentTime, sentDate: classTime, reasonOfAbsence: message, sender: sender, classTime: classDate, teacher: teacher))
                    }
                }
                completion()
            }
        }
    }
    
    func numberOfRows() -> Int {
        return message.count
    }
    
    func cellViewModel(for indexPath: IndexPath) -> MessageCollectionViewCellViewModelType? {
        let message = message[indexPath.row]
        return MessageCollectionViewCellViewModel(message: message)
    }
}
