//
//  CreateAccountVC.swift
//  FishermenLabs
//
//  Created by Lily Hofman on 11/22/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CreateAccountVC: UIViewController{
    @IBOutlet var rootView: UIView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        if let username = emailTextField.text, let password = passwordTextField.text{
            AuthService.singleton.createAccount(sender: self, email: username, password: password, completed: {
                if let firebaseUser: User = Auth.auth().currentUser{
                    DataService.singleton.createUser(currentUserUID: firebaseUser.uid)
                    self.dismiss(animated: true, completion: nil)
                }else{
                    GlobalActions.singleton.displayAlert(sender: self, title: "Error on account creation", message: "Try again with different credentials")
                }
            })
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
