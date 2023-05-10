//
//  DatabaseManager.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 18.03.2023.
//

import FirebaseFirestore
import Foundation

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    let database = Firestore.firestore()
    
    func findUser(with email: String, completion: @escaping (String, String) -> Void) {
        let ref = database.collection("teachers").whereField("email", isEqualTo: email)
        
        
        ref.getDocuments { snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("SNAPSHOT WASN'T FOUND")
                return
            }
            
            let name = snapshot.documents.first?.get("name") as? String ?? ""
            let surname = snapshot.documents.first?.get("surname") as? String ?? ""
            completion(name, surname)
        }
    }
}

