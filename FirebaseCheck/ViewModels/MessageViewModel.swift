//
//  MessageViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 26.04.2023.
//

import Foundation

class MessageViewModel: MessageViewModelType {
    var messageCollectionViewViewModel: MessageCollectionViewViewModelType?
 
    init(messageCollectionViewViewModel: MessageCollectionViewViewModelType? = nil) {
        self.messageCollectionViewViewModel = messageCollectionViewViewModel
    }
}
