//
//  StatisticsViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 08.05.2023.
//

import Foundation

class StatisticsViewModel: StatisticsViewModelType {
    var statisticsCollectionViewViewModel: StatisticsCollectionViewViewModelType?
 
    init(statisticsCollectionViewViewModel: StatisticsCollectionViewViewModelType? = nil) {
        self.statisticsCollectionViewViewModel = statisticsCollectionViewViewModel
    }
}
