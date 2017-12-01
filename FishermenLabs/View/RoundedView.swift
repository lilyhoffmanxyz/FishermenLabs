//
//  RoundedView.swift
//  FishermenLabs
//
//  Created by Lily Hofman on 11/23/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit

class RoundedView: UIView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
        layer.borderWidth = 5.0
        layer.cornerRadius = 15.0
        
    }
}
