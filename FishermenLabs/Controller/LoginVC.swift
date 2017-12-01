//
//  LoginVC.swift
//  FishermenLabs
//
//  Created by Lily Hofman on 11/22/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginVC: UIViewController{
    @IBOutlet var usernameTextField: RoundedUITextField!
    @IBOutlet var passwordTextField: RoundedUITextField!
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        usernameTextField.text = ""
        passwordTextField.text = ""
        performSegue(withIdentifier: "CreateAccount", sender: nil)
    }
    @IBAction func signInButtonTapped(_ sender: Any) {
        if let username = usernameTextField.text, let password = passwordTextField.text{
            AuthService.singleton.signIn(sender: self, email: username, password: password, completed: {(success, message) in
                if(success){
                    self.performSegue(withIdentifier: "Login", sender: nil)
                }else{
                    GlobalActions.singleton.displayAlert(sender: self, title: "User Not Found", message: message)
                }
            })
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addTapToDismissKeyboard()
    }
    func addTapToDismissKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
