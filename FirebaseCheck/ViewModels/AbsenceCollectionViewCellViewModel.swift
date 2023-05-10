//
//  AbsenceCollectionViewCellViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 09.05.2023.
//

import Foundation

class AbsenceCollectionViewCellViewModel: AbsenceCollectionViewCellViewModelType {
    
    init(absence: Absence) {
        self.absence = absence
    }
    
    private let absence: Absence
    
    var date: String {
        return absence.date
    }
    
    var hour: String {
        return absence.hour
    }
}
