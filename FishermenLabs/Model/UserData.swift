//
//  UserData.swift
//  FishermenLabs
//
//  Created by Lily Hofman on 11/22/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit

class UserData{
    //only saved users get UIDs - for firebase storage
    var uid: String?
    
    //Data pulled from randomuser.me
    var firstName: String!
    var lastName: String!
    var nationality: String!
    var street: String!
    var city: String!
    var state: String!
    var zipcode: String!
    var email: String!
    var birthday: String!
    var phone: String!
    var cell: String!
    var photoURL: String!
    


    //Get only
    var name: String{
        return self.firstName.capitalized + " " + self.lastName.capitalized
    }
    var age: Int{
        let year = Calendar.current.component(.year, from: Date())
        let indexEndOfBirthYear = self.birthday.index(of: "-")
        let birthYear = Int(self.birthday.substring(to: indexEndOfBirthYear!))!
        return year-birthYear
    }
    
    var photo: UIImage{
        if let url = URL(string: self.photoURL){
            if let data = NSData(contentsOf: url){
                let image = UIImage(data: data as Data)
                if image != nil{
                    return image!
                }
            }
        }
        return #imageLiteral(resourceName: "fish")
    }
    
    var nationalityImage: UIImage{
        switch(self.nationality){
        case "AU": //Australia
            return #imageLiteral(resourceName: "australia")
        case "BR": //Brazil
            return #imageLiteral(resourceName: "brazil")
        case "CA": //Canada
            return #imageLiteral(resourceName: "canada")
        case "CH": //Switzerland
            return #imageLiteral(resourceName: "switzerland")
        case "DE": //Germany
            return #imageLiteral(resourceName: "germany")
        case "DK": //Denmark
            return #imageLiteral(resourceName: "denmark")
        case "ES": //Spain
            return #imageLiteral(resourceName: "spain")
        case "FI": //Finland
            return #imageLiteral(resourceName: "finland")
        case "FR": //France
            return #imageLiteral(resourceName: "france")
        case "GB": //United Kingdom
            return #imageLiteral(resourceName: "unitedkingdom")
        case "IE": //Ireland
            return #imageLiteral(resourceName: "irealand")
        case "IR": //Iran
            return #imageLiteral(resourceName: "iran")
        case "NL": //Netherlands
            return #imageLiteral(resourceName: "netherlands")
        case "NZ": //New Zealand
            return #imageLiteral(resourceName: "newzealand")
        case "TR": //Turkey
            return #imageLiteral(resourceName: "turkey")
        case "US": //United States
            return #imageLiteral(resourceName: "usa")
        default:
            return #imageLiteral(resourceName: "fishing")
        }
    }
    
    var address: String{
        return self.street.capitalized + "\n" + self.city.capitalized + ", " + self.state.capitalized + "\n" + String(self.zipcode)
    }
    
    init(firstName: String, lastName: String, nationality: String, street: String, city: String, state: String, zipcode: String, email: String, birthday: String, phone: String, cell: String, photoURL: String){
        self.firstName = firstName
        self.lastName = lastName
        self.nationality = nationality
        self.street = street
        self.city = city
        self.state = state
        self.zipcode = zipcode
        self.email = email
        self.birthday = birthday
        self.phone = phone
        self.cell = cell
        self.photoURL = photoURL
    }
}
