//
//  MessageViewModelType.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 26.04.2023.
//

import Foundation

protocol MessageViewModelType: AnyObject {
    var messageCollectionViewViewModel: MessageCollectionViewViewModelType? {get}
}
