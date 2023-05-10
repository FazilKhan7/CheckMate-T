//
//  MessageCollectionViewCellViewModelType.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 26.04.2023.
//

import Foundation

protocol MessageCollectionViewCellViewModelType: AnyObject {
    var subCode: String { get }
    var sendTime: String { get }
    var sendDate: String { get }
    var reasonOfAbsence: String { get }
    var sender: String { get }
    var classTime: String { get }
    var teacher: String { get }
}
