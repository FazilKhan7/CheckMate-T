//
//  StudentCollectionViewCellViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 30.03.2023.
//

import Foundation

class StudentCollectionViewCellViewModel: StudentCollectionViewCellViewModelType {
    
    private let student: StudentInfo
    
    init(student: StudentInfo) {
        self.student = student
    }
    
    var name: String {
        return student.name
    }
    
    var surname: String {
        return student.surname
    }
    
    var status: Bool {
        return student.status
    }
    
    var attCount: Int {
        return student.attCount
    }
    
    var id: String {
        return student.id
    }
}
