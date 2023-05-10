//
//  AccountInfoViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 18.03.2023.
//

import Foundation

class AccountInfoViewModel: AccountInfoViewModelType {
    
    let student: Student
    
    var fullName: String {
        return "\(student.name) \(student.surname)"
    }
    
    var email: String {
        print("EMAILLL")
        return student.email
    }
    
    init(student: Student) {
        self.student = student
    }
}
