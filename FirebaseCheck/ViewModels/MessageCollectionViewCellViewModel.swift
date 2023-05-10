//
//  MessageCollectionViewCellViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 26.04.2023.
//

import Foundation

class MessageCollectionViewCellViewModel: MessageCollectionViewCellViewModelType {
    
    private let message: ReasonMessage
    
    init(message: ReasonMessage) {
        self.message = message
    }
    
    var subCode: String {
        return message.subCode
    }
    
    var sendTime: String {
        return message.sendTime
    }
    
    var sendDate: String {
        return message.sentDate
    }
    
    var reasonOfAbsence: String {
        return message.reasonOfAbsence
    }
    
    var sender: String {
        return message.sender
    }
    
    var classTime: String {
        return message.classTime
    }
    
    var teacher: String {
        return message.teacher
    }
}
