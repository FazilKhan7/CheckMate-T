//
//  HomeViewModel.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 18.03.2023.
//

import Foundation

class HomeViewModel: HomeViewModelType {
    let student = Student(name: "Alexandr", surname: "Ivanov", email: "alexandr.ivanov@sdu.edu.kz")
    
    var collectionViewViewModel: CollectionViewViewModelType?
    var accountInfoViewModel: AccountInfoViewModelType?
   
    
    init(collectionViewViewModel: CollectionViewViewModelType, accountInfoViewModel: AccountInfoViewModelType) {
        self.collectionViewViewModel = collectionViewViewModel
//        collectionViewViewModel.querySubjects(name: student.name, surname: student.surname)
        self.accountInfoViewModel = accountInfoViewModel
    }
}
