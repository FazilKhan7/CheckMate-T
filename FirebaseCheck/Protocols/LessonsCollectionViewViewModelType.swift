//
//  LessonsCollectionViewViewModelType.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 24.03.2023.
//

import Foundation

protocol LessonsCollectionViewViewModelType: AnyObject {
    func queryLessons(name: String, surname: String, code: String, day: String, month: String, year: String, completion: @escaping () -> Void)
    func numberOfRows() -> Int
    func cellViewModel(for indexPath: IndexPath) -> LessonsCollectionViewCellViewModelType?
}
