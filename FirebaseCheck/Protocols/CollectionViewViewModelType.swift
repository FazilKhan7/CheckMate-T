//
//  CollectionViewViewModelType.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 18.03.2023.
//

import Foundation

protocol CollectionViewViewModelType: AnyObject {
    func querySubjects(name: String, surname: String, completion: @escaping () -> Void)
    func numberOfRows() -> Int
    func cellViewModel(for indexPath: IndexPath) -> CollectionViewCellViewModelType?
}



