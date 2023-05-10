//
//  HomeViewModelType.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 18.03.2023.
//

import Foundation

protocol HomeViewModelType: AnyObject {
    var collectionViewViewModel: CollectionViewViewModelType? {get}
    var accountInfoViewModel: AccountInfoViewModelType? {get}
}
