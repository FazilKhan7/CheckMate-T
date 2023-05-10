//
//  StudentCollectionViewViewModelType.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 29.03.2023.
//

import Foundation

protocol StudentCollectionViewViewModelType: AnyObject {
    func queryLessons(name: String, surname: String, code: String, day: String, month: String, year: String, completion: @escaping () -> Void)
    func numberOfRows() -> Int
    func cellViewModel(for indexPath: IndexPath) -> StudentCollectionViewCellViewModelType?
}
