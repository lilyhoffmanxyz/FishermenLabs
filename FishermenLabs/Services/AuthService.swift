//
//  AuthService.swift
//  FishermenLabs
//
//  Created by Lily Hofman on 11/22/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import Firebase

class AuthService{
    
    private static let _singleton = AuthService()
    static var singleton: AuthService{
        return _singleton
    }
    
    
    func createAccount(sender: UIViewController, email: String, password: String, completed: @escaping () -> ()){
        Auth.auth().createUser(withEmail: email, password: password, completion: {(user, error) in
            if error == nil{
                if user != nil{
                    print("success")
                }else{
                    GlobalActions.singleton.displayAlert(sender: sender, title: "Authentication Error", message: "\(error!.localizedDescription)")
                }
            }else{
                GlobalActions.singleton.displayAlert(sender: sender, title: "Error on Account Creation", message: "\(error!.localizedDescription)")
            }
            completed()
        })
    }
    

    
    func signIn(sender: UIViewController, email: String, password: String, completed: @escaping (Bool, String) -> ()){
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil && user != nil{
                GlobalActions.singleton.displayAlert(sender: sender, title: "Login Error", message: error!.localizedDescription)
                completed(false, error!.localizedDescription)
            }
            if user == nil{
                GlobalActions.singleton.displayAlert(sender: sender, title: "Login Error", message: error!.localizedDescription)
                completed(false, "authenticaion error")
            }
            if error == nil && user != nil{
                completed(true, "success")
            }
        })
    }
    
    func signOut(sender: UIViewController){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            sender.dismiss(animated: true, completion: nil)
        }catch let signOutError as NSError {
            GlobalActions.singleton.displayAlert(sender: sender, title: "Log out Error", message: "\(signOutError.localizedDescription)")
            return
        }
    }

    
    
}

