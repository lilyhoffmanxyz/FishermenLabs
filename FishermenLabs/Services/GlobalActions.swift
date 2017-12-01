//
//  GlobalActions.swift
//  FishermenLabs
//
//  Created by Lily Hofman on 11/24/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit

class GlobalActions{
    private static let _singleton = GlobalActions()
    static var singleton: GlobalActions{
        return _singleton
    }
    
    func displayAlert(sender: UIViewController, title: String, message: String){
        let errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAlert = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in })
        errorAlert.addAction(dismissAlert)
        sender.present(errorAlert, animated: true, completion: nil)
    }
}

