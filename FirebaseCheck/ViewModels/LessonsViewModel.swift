//
//  LessonsViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 24.03.2023.
//

import Foundation

class LessonsViewModel: LessonsViewModelType {
    var lessonsCollectionViewViewModel: LessonsCollectionViewViewModelType?
 
    init(lessonsCollectionViewViewModel: LessonsCollectionViewViewModelType? = nil) {
        self.lessonsCollectionViewViewModel = lessonsCollectionViewViewModel
    }
}
