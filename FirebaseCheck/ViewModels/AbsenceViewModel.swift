//
//  AbsenceViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 09.05.2023.
//

import Foundation

class AbsenceViewModel: AbsenceViewModelType {
    var absenceCollectionViewViewModel: AbsenceCollectionViewViewModelType?
 
    init(absenceCollectionViewViewModel: AbsenceCollectionViewViewModelType? = nil) {
        self.absenceCollectionViewViewModel = absenceCollectionViewViewModel
    }
}
