//
//  LessonsCollectionViewCellViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 24.03.2023.
//

import Foundation

class LessonsCollectionViewCellViewModel: LessonsCollectionViewCellViewModelType {
    
    private let lessons: Lessons
    
    init(lessons: Lessons) {
        self.lessons = lessons
    }
    
    var subjectCode: String {
        let startIndex = lessons.subjectCode.index(lessons.subjectCode.startIndex, offsetBy: 6)
        let endIndex = lessons.subjectCode.index(lessons.subjectCode.endIndex, offsetBy: -1)
        let range = startIndex...endIndex
        let substring = String(lessons.subjectCode[range])
        return String(substring)
    }
    
    var subjectName: String {
        return lessons.subjectName
    }
    
    var startTime: String {
        return lessons.startTime
    }
    
    var endTime: String {
        return lessons.endTime
    }
    
    var todaysDay: String {
        
        let startDay = lessons.todaysDay.index(lessons.todaysDay.startIndex, offsetBy: 0)
        let endDay = lessons.todaysDay.index(lessons.todaysDay.startIndex, offsetBy: 2)
        let rangeDay = startDay..<endDay
        let day = String(lessons.todaysDay[rangeDay])
        
        let startMonth = lessons.todaysDay.index(lessons.todaysDay.startIndex, offsetBy: 3)
        let endMonth = lessons.todaysDay.index(lessons.todaysDay.startIndex, offsetBy: 5)
        let rangeMonth = startMonth..<endMonth
        let month = String(lessons.todaysDay[rangeMonth])
        
        let startYear = lessons.todaysDay.index(lessons.todaysDay.startIndex, offsetBy: 6)
        let endYear = lessons.todaysDay.index(lessons.todaysDay.endIndex, offsetBy: -1)
        let rangeYear = startYear...endYear
        let year = String(lessons.todaysDay[rangeYear])
    
        let monthName = DateFormatter().monthSymbols[Int(month)! - 1]
        
        return "\(String(day))th \(String(describing: monthName)), \(year)"
    }
    
    var titleCode: String {
        let startCodeIndex = lessons.titleCode.index(lessons.titleCode.startIndex, offsetBy: 0)
        let endCodeIndex = lessons.titleCode.index(lessons.titleCode.startIndex, offsetBy: 5)
        let rangeCode = startCodeIndex...endCodeIndex
        let substring = String(lessons.titleCode[rangeCode])
        
        return String(substring)
    }
}
