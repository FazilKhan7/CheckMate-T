//
//  StatisticsCollectionViewCellViewModelType.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 08.05.2023.
//

import Foundation

protocol StatisticsCollectionViewCellViewModelType: AnyObject {
    var subjectCode: String {get}
    var subjectName: String {get}
    var totalAttendanceCount: Int {get}
    var presenceCount: Int {get}
    var absenceCount: Int {get}
    var id: String {get}
}
