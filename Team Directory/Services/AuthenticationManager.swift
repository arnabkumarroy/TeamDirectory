//
//  AuthenticationManager.swift
//  Team Directory
//
//  Created by Arnab Roy on 2/9/19.
//  Copyright © 2019 RoyInc. All rights reserved.
//

import Firebase

class AuthenticationManager {
    
    func signUp(withEmail email:String, password pwd:String, completion : @escaping (Bool,String) -> () ) {
        
        Auth.auth().createUser(withEmail: email, password: pwd) { (authResult, error) in
            guard let user = authResult?.user else {
                completion(false,error?.localizedDescription ?? "")
                return
            }
            
            completion(true, "")
        }
    }
    
    func signIn(userName user:String, password pwd:String, completion : @escaping (Bool) -> () ) {
        Auth.auth().signIn(withEmail: user, password: pwd) { (user, error) in
            
            guard let _ = user else {
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    static func signOut(completion : @escaping (Bool) -> ()) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            completion(true)
        } catch {
            completion(false)
        }
    }
}

