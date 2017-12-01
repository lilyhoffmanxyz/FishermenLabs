//
//  RandomUsersVC.swift
//  FishermenLabs
//
//  Created by Lily Hofman on 11/22/17.
//  Copyright © 2017 Lily Hoffman. All rights reserved.
//

import Foundation
import UIKit

class RandomUsersVC: UIViewController{
    var randomUsers = [UserData]()
    var filteredRandomUsers = [UserData]()
    var searchActive: Bool = false
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(RandomUsersVC.handleRefresh), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBAction func signOutButtonTapped(_ sender: Any) {
        AuthService.singleton.signOut(sender: self)
        performSegue(withIdentifier: "SignOut", sender: nil)
    }
    @IBAction func savedUsersButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "ViewSavedUsers", sender: nil)
    }
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.addSubview(self.refreshControl)
        searchBar.delegate = self

        DataService.singleton.requestUsers(completed: { (users) in
            self.randomUsers = users
            self.tableView.reloadData()
        })
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ViewUserDetails"){
            let dest = segue.destination as! UserDetailsVC
            dest.user = sender as! UserData
        }
    }
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        DataService.singleton.requestUsers(completed: { (users) in
            self.randomUsers = users
            self.tableView.reloadData()
            //self.searchActive = false
            refreshControl.endRefreshing()

        })
    }

}

extension RandomUsersVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive{
            return filteredRandomUsers.count
        }else{
            return randomUsers.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath)
        if searchActive{
            cell.textLabel?.text = filteredRandomUsers[indexPath.row].name

        }else{
            cell.textLabel?.text = randomUsers[indexPath.row].name
        }
        return cell
    }
}

extension RandomUsersVC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(searchActive){
            performSegue(withIdentifier: "ViewUserDetails", sender: filteredRandomUsers[indexPath.row])
        }else{
            performSegue(withIdentifier: "ViewUserDetails", sender: randomUsers[indexPath.row])
        }
    }
}

extension RandomUsersVC: UISearchBarDelegate{
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        self.tableView.reloadData()

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.tableView.reloadData()

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.tableView.reloadData()

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredRandomUsers = randomUsers.filter({ (text) -> Bool in
            let firstName: NSString = text.firstName as NSString
            let lastName: NSString = text.lastName as NSString
            
            let firstNameRange = firstName.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            let lastNameRange = lastName.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            
            return firstNameRange.location != NSNotFound || lastNameRange.location != NSNotFound
        })
        if(filteredRandomUsers.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        
        self.tableView.reloadData()
    }
}
