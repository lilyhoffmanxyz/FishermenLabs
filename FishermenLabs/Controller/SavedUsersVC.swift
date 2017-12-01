//
//  SavedUsersVC.swift
//  FishermenLabs
//
//  Created by Lily Hofman on 11/24/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class SavedUsersVC: UIViewController{
    var currentUser: User! //firebase authenicated app user
    var savedUsers = [UserData]()
    
    @IBOutlet var tableview: UITableView!
    override func viewDidLoad() {
        currentUser = Auth.auth().currentUser //Auth = firebase authentication
        tableview.delegate = self
        tableview.dataSource = self

        DataService.singleton.observeSavedUsers(currentUserUID: currentUser.uid, completed: {(users) in
            self.savedUsers = users
            self.tableview.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ViewSavedUserDetails"){
            let dest = segue.destination as! UserDetailsVC
            dest.user = sender as! UserData
            dest.enableSavingUsers = false
        }
    }

}


extension SavedUsersVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedUsers.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        cell.textLabel?.text = savedUsers[indexPath.row].name
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            DataService.singleton.deleteSavedUser(currentUserUID: currentUser.uid, savedUserUID: savedUsers[indexPath.row].uid!)
            self.savedUsers.remove(at: indexPath.row)
            self.tableview.reloadData()
        }
    }

}

extension SavedUsersVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ViewSavedUserDetails", sender: savedUsers[indexPath.row])
    }
}
