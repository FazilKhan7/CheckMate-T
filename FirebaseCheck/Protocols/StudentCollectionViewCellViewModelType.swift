//
//  StudentCollectionViewCellViewModelType.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 29.03.2023.
//

import Foundation

protocol StudentCollectionViewCellViewModelType: AnyObject {
    var name: String { get }
    var surname: String { get }
    var status: Bool { get }
    var attCount: Int { get }
    var id: String { get }
}
