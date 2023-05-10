//
//  StatisticsCollectionViewViewModelType.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 08.05.2023.
//

import Foundation

protocol StatisticsCollectionViewViewModelType: AnyObject {
    func queryLessons(id: String, completion: @escaping ([StudentStatistics]) -> Void)
    func numberOfRows() -> Int
    func cellViewModel(for indexPath: IndexPath) -> StatisticsCollectionViewCellViewModelType?
}
