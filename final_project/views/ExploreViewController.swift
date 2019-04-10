//
//  ExploreViewController.swift
//  final_project
//
//  Created by liblabs-mac on 3/2/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ExploreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var groupList = [Group]()
    var searchActive: Bool = false
    var filteredGroupList: [Group] = []
    
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        searchBar.placeholder = "Search groups..."
        
        databaseRef = Database.database().reference().child("Groups")
        retrieveGroups()
    }
    
    func retrieveGroups() {
        databaseRef?.observe(.value, with: { snapshot in
                
                self.groupList = []
                
                for item in snapshot.children {
                    let actItem = item as? DataSnapshot
                    self.groupList.append(Group(snapshot: actItem!))
                }
                
                self.tableView.reloadData()
        })
    }
    
    @IBAction func addGroupButtonClicked(_ sender: Any) {
        performSegue(withIdentifier: "addGroup", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchActive = false
        } else {
            searchActive = true
            filteredGroupList = []
            for group in groupList {
                if group.name.lowercased().contains(searchText.lowercased()) {
                    filteredGroupList.append(group)
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    var currentGroup: Group?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentGroup = groupList[indexPath.row]
        performSegue(withIdentifier: "unwindToPosts", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (searchActive ? filteredGroupList.count : groupList.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell
    
        let group = searchActive ? filteredGroupList[indexPath.row] : groupList[indexPath.row]

        cell?.groupLabel.text = group.name
        cell?.groupDescription.text = group.desc
        
        return cell!
    }
    
    @IBAction func unwindToExplore(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindToPosts" {
            let destVC = segue.destination as? PostsViewController
            destVC?.groupName = currentGroup!.name
        }
    }
}
