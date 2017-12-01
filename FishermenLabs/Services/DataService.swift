//
//  DataService.swift
//  FishermenLabs
//
//  Created by Lily Hofman on 11/22/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//
/* This is a singleton class that handles data transfer requests from Firebase and from randomuser.me
 */

import Foundation
import Alamofire
import Firebase

let FIREBASE_DB_BASE = Database.database().reference()

class DataService{
    //MARK: DataService Singleton
    private static let _singleton = DataService()
    static var singleton: DataService{
        return _singleton
    }

    //Requests random users from randomuser.me
    func requestUsers(completed: @escaping ([UserData]) -> ()){
        var randomUsers = [UserData]()
        Alamofire.request("https://randomuser.me/api/?results=100").responseJSON(completionHandler: {(response) in
            if let json = response.result.value as? Dictionary<String, AnyObject>{
                if let results = json["results"] as? NSArray{
                    for result in results{
                        if let userDict = result as? Dictionary<String, AnyObject>{
                            let firstName = userDict["name"]!["first"] as! String
                            let lastName = userDict["name"]!["last"] as! String
                            let street = userDict["location"]!["street"] as! String
                            let city = userDict["location"]!["city"] as! String
                            let state = userDict["location"]!["state"] as! String
                            
                            var zipcode = "00000"
                            if let postcode = userDict["location"]!["postcode"] as? NSString{
                                zipcode = postcode as String
                            }
                            if let postcode = userDict["location"]!["postcode"] as? NSNumber{
                                zipcode = String(describing: postcode)
                            }
                            
                            let email = userDict["email"] as! String
                            let birthday = userDict["dob"] as! String
                            let phone = userDict["phone"] as! String
                            let cell = userDict["cell"] as! String
                            let photoURL = userDict["picture"]!["large"] as! String
                            let nationality = userDict["nat"] as! String
                            let user = UserData(firstName: firstName, lastName: lastName, nationality: nationality, street: street, city: city, state: state, zipcode: zipcode, email: email, birthday: birthday, phone: phone, cell: cell, photoURL: photoURL)
                            randomUsers.append(user)
                        }
                    }
                }
            }
            completed(randomUsers)
        })
    }
    
    func createUser(currentUserUID: String){
        FIREBASE_DB_BASE.child(currentUserUID).setValue(Dictionary<String, AnyObject>())
    }
    
    func saveUser(currentUserUID: String, userToSave: UserData) -> String{
        let userReference = UUID().uuidString
        let savedUser: Dictionary<String, AnyObject> = [
            "firstName": userToSave.firstName as AnyObject,
            "lastName": userToSave.lastName as AnyObject,
            "nationality": userToSave.nationality as AnyObject,
            "street": userToSave.street as AnyObject,
            "city": userToSave.city as AnyObject,
            "state": userToSave.state as AnyObject,
            "zipcode": userToSave.zipcode as AnyObject,
            "email": userToSave.email as AnyObject,
            "birthday": userToSave.birthday as AnyObject,
            "phone": userToSave.phone as AnyObject,
            "cell": userToSave.cell as AnyObject,
            "photoURL": userToSave.photoURL as AnyObject,
        ]
        FIREBASE_DB_BASE.child(currentUserUID).child(userReference).setValue(savedUser)
        return userReference

    }
    func observeSavedUsers(currentUserUID: String, completed: @escaping ([UserData]) -> ()){
        var savedUsers = [UserData]()
        
        FIREBASE_DB_BASE.child(currentUserUID).observeSingleEvent(of: .value, with:  { (snapshot) in
            for child in snapshot.children{
                let user = child as! DataSnapshot
                let uid = user.key
                let firstName = user.childSnapshot(forPath: "firstName").value as! String
                let lastName = user.childSnapshot(forPath: "lastName").value as! String
                let nationality = user.childSnapshot(forPath: "nationality").value as! String
                let street = user.childSnapshot(forPath: "street").value as! String
                let city = user.childSnapshot(forPath: "city").value as! String
                let state = user.childSnapshot(forPath: "state").value as! String
                let zipcode = user.childSnapshot(forPath: "zipcode").value as! String
                let email = user.childSnapshot(forPath: "email").value as! String
                let birthday = user.childSnapshot(forPath: "birthday").value as! String
                let phone = user.childSnapshot(forPath: "phone").value as! String
                let cell = user.childSnapshot(forPath: "cell").value as! String
                let photoURL = user.childSnapshot(forPath: "photoURL").value as! String
                
                let savedUser = UserData(firstName: firstName, lastName: lastName, nationality: nationality, street: street, city: city, state: state, zipcode: zipcode, email: email, birthday: birthday, phone: phone, cell: cell, photoURL: photoURL)
                savedUser.uid = uid
                savedUsers.append(savedUser)
            }
            completed(savedUsers)
        })
    }
    
    func deleteSavedUser(currentUserUID: String, savedUserUID: String){
        FIREBASE_DB_BASE.child(currentUserUID).child(savedUserUID).removeValue()
    }
}
