//
//  StudentViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 30.03.2023.
//

import Foundation

class StudentViewModel: StudentViewModelType {
    var studentCollectionViewViewModel: StudentCollectionViewViewModelType?
 
    init(studentCollectionViewViewModel: StudentCollectionViewViewModelType? = nil) {
        self.studentCollectionViewViewModel = studentCollectionViewViewModel
    }
}
