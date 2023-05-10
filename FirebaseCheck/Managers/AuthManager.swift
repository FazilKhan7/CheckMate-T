//
//  AuthManager.swift
//  FirebaseCheck
//
//  Created by Bakhtiyarov Fozilkhon on 18.03.2023.
//

import FirebaseAuth
import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    
    private init() {}
    let auth = Auth.auth()
    
    public var isSignedIn: Bool {
        return auth.currentUser != nil
    }
    
    public func signIn(
        email: String,
        password: String,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        auth.signIn(withEmail: email, password: password) { result, error in
            guard let result = result, error == nil else {
                completion(.failure(error!))
                print("USER WAS NOT FOUND!!!")
                return
            }
            
            DatabaseManager.shared.findUser(with: email) { name, surname in
                UserDefaults.standard.setValue(name, forKey: "name")
                UserDefaults.standard.setValue(surname, forKey: "surname")
                UserDefaults.standard.setValue(result.user.email, forKey: "email")
                
                completion(.success(result.user))
            }
        }
    }
    
    public func signOut(completion: @escaping (Bool) -> Void) {
            do {
                try auth.signOut()
                completion(true)
            } catch {
                print(error)
                completion(false)
            }
        }
    
}
