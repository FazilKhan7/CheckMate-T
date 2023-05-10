//
//  AbsenceCollectionViewCellViewModelType.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 09.05.2023.
//

import Foundation

protocol AbsenceCollectionViewCellViewModelType: AnyObject {
    var date: String { get }
    var hour: String { get }
}
