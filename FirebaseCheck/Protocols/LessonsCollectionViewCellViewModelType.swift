//
//  LessonsCollectionViewCellViewModelType.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 24.03.2023.
//
import Foundation

protocol LessonsCollectionViewCellViewModelType: AnyObject {
    var subjectCode: String { get }
    var subjectName: String { get }
    var startTime: String { get }
    var endTime: String { get }
    var todaysDay: String { get }
    var titleCode: String { get }
}
