//
//  UserDetailsVC.swift
//  FishermenLabs
//
//  Created by Lily Hofman on 11/23/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import MessageUI


class UserDetailsVC: UIViewController{
    var user: UserData!
    var currentUser: User! //Firebase authorized user
    var enableSavingUsers: Bool = true
    
    @IBOutlet var photo: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageLabel: UILabel!
    @IBOutlet var emailAddressButton: UIButton!
    @IBOutlet var cellPhoneNumberButton: UIButton!
    @IBOutlet var homePhoneNumberButton: UIButton!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var nationalityBackgroundPhoto: UIImageView!
    @IBOutlet var saveUserButton: RoundedButton!
    
    @IBAction func emailButtonTapped(_ sender: Any) {
        //Obtain a configured MFMailComposeViewController
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients([user.email])
        
        //Check that device can send mail and present email view
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            GlobalActions.singleton.displayAlert(sender: self, title: "Error sending email", message: "Your device could not send e-mail.  Please check your device's e-mail configuration and try again")
        }
    }
    
    @IBAction func cellPhoneButtonTapped(_ sender: Any) {
        let phoneNumber = user.cell!
        if let phoneCallURL = URL(string: "tel://\(String(describing: phoneNumber))") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    @IBAction func homePhoneButtonTapped(_ sender: Any) {
        let phoneNumber = user.phone!
        if let phoneCallURL = URL(string: "tel://\(String(describing: phoneNumber))") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func saveUserButtonTapped(_ sender: Any) {
        let savedUserUID = DataService.singleton.saveUser(currentUserUID: currentUser.uid, userToSave: user)
        user.uid = savedUserUID
        saveUserButton.setTitle("Saved!", for: .normal)
        saveUserButton.isEnabled = false
    }
    
    override func viewDidLoad() {
        currentUser = Auth.auth().currentUser
        
        if(enableSavingUsers == false){
            saveUserButton.removeFromSuperview()
        }
        
        nationalityBackgroundPhoto.image = user.nationalityImage
        nationalityBackgroundPhoto.clipsToBounds = true
        photo.image = user.photo
        nameLabel.text = user.name
        ageLabel.text = String(user.age) + " years old"
        emailAddressButton.setTitle(user.email, for: .normal)
        cellPhoneNumberButton.setTitle(user.cell, for: .normal)
        homePhoneNumberButton.setTitle(user.phone, for: .normal)
        addressLabel.text = user.address
        
    }
    
}

extension UserDetailsVC: MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
