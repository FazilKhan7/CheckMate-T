//
//  MessageCollectionViewViewModelType.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 26.04.2023.
//

import Foundation

protocol MessageCollectionViewViewModelType: AnyObject {
    func queryLessons(code: String, completion: @escaping () -> Void)
    func numberOfRows() -> Int
    func cellViewModel(for indexPath: IndexPath) -> MessageCollectionViewCellViewModelType?
}
