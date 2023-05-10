//
//  StatisticsCollectionViewCellViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 08.05.2023.
//

import Foundation

class StatisticsCollectionViewCellViewModel: StatisticsCollectionViewCellViewModelType {
    
    private let statistics: StudentStatistics
    
    init(statistics: StudentStatistics) {
        self.statistics = statistics
    }
    
    var subjectCode: String {
        return statistics.subjectCode
    }
    
    var subjectName: String {
        return statistics.subjectName
    }
    
    var totalAttendanceCount: Int {
        return statistics.totalAttendanceCount
    }
    
    var presenceCount: Int {
        return statistics.presenceCount
    }
    
    var absenceCount: Int {
        return statistics.absenceCount
    }
    
    var id: String {
        return statistics.id
    }
}
