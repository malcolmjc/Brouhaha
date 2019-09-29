//
//  GroupViewController.swift
//  Brouhaha
//
//  Created by Malcolm Craney on 4/30/19.
//  Copyright © 2019 Malcolm Craney. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var subgroupList = [Subgroup]()
    
    var databaseRef: DatabaseReference!
    @IBOutlet weak var supergroupNameLabel: UILabel!
    var groupName: String!
    
    func setupBackButton() {
        let backButton: UIBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItem.Style.plain,
                            target: self, action: #selector(backPressed(_:)))
        navBar.backBarButtonItem = backButton
        navBar.leftBarButtonItem = backButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackButton()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        
        tableView.reloadData()
        supergroupNameLabel.text = groupName
        databaseRef = Database.database().reference().child("Groups").child(groupName)
        groupExists()
    }
    
    var backPressed = false
    @IBAction func backPressed(_ sender: Any) {
        backPressed = true
        performSegue(withIdentifier: "unwindToExplore", sender: self)
    }
    
    func groupExists() {
        databaseRef?.observe(.value, with: { snapshot in
            
            if snapshot.childrenCount == 0 {
                let newGroup = Group(self.groupName)
                self.databaseRef.setValue(newGroup.toAnyObject())
            }
            
            else {
                self.retrieveGroups()
            }
        })
    }
    
    @IBOutlet weak var navBar: UINavigationItem!
    func retrieveGroups() {
        databaseRef?.child("subgroups").observe(.value, with: { snapshot in
            
            self.subgroupList = []
            
            for item in snapshot.children {
                let actItem = item as? DataSnapshot
                self.subgroupList.append(Subgroup(snapshot: actItem!))
            }
            
            self.tableView.reloadData()
        })
    }
    
    @IBAction func addSubgroupButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "addSubgroup", sender: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    var currentGroup: Subgroup?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentGroup = subgroupList[indexPath.row]
        performSegue(withIdentifier: "unwindToExplore", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subgroupList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subgroupCell", for: indexPath) as? SubgroupCell
        
        let subgroup = subgroupList[indexPath.row]
        
        cell?.subgroupNameLabel.text = subgroup.name
        cell?.subgroupDescLabel.text = subgroup.desc
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSubgroup" {
            let destVC = segue.destination as? CreateGroupViewController
            destVC?.supergroupName = groupName
        }
        if segue.identifier == "unwindToExplore" {
            let destVC = segue.destination as? ExploreViewController
            destVC?.subgroupName = currentGroup?.name ?? ""
            destVC?.transitionToPosts = !backPressed
        }
    }
    
    @IBAction func unwindToGroup(segue: UIStoryboardSegue) {
    }
}

