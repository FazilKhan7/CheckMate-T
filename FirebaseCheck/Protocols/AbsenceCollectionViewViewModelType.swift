//
//  AbsenceCollectionViewViewModelType.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 09.05.2023.
//

import Foundation

protocol AbsenceCollectionViewViewModelType: AnyObject {
    func queryLessons(code: String, id: String, completion: @escaping () -> Void)
    func numberOfRows() -> Int
    func cellViewModel(for indexPath: IndexPath) -> AbsenceCollectionViewCellViewModelType?
}
