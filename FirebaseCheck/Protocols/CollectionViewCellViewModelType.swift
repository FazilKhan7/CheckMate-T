//
//  CollectionViewCellViewModelType.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 18.03.2023.
//

import Foundation

protocol CollectionViewCellViewModelType: AnyObject {
    var subjectCode: String { get }
    var subjectName: String { get }
}
