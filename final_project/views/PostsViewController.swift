//
//  FirstViewController.swift
//  final_project
//
//  Created by liblabs-mac on 3/2/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MJRefresh

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var addPost: UIButton!
    
    var groupName: String?
    var messageList = [TextPost]()
    
    var databaseRef : DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        
        groupTitleLabel.text = groupName ?? "Cal Poly"
        
        databaseRef = Database.database().reference().child("Groups").child(groupTitleLabel.text!).child("posts")
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(FirstViewController.refreshPosts))
        
        retrievePosts()
    }
    
    @IBAction func refreshPosts() {
        retrievePosts()
        self.tableView.mj_header.endRefreshing()
    }
    
    @IBAction func retrievePosts() {
        databaseRef?.queryOrdered(byChild: "posts")
            .observe(.value, with:
            { snapshot in
                
                self.messageList = []
                
                for item in snapshot.children {
                    let actItem = item as! DataSnapshot
                    self.messageList.append(TextPost(snapshot: actItem))
                }
                
                self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell
        
        let message = messageList[indexPath.row]
        
        cell?.messageLabel.text = message.content
        
        if cell!.upvoted {
            message.voteCount += 1
        }
        
        else if cell!.downvoted {
            message.voteCount -= 1
        }
    
        cell?.voteLabel.text = String(message.voteCount)
        
        return cell!
    }
    
    @IBAction func unwindToPosts(segue: UIStoryboardSegue) {
        groupTitleLabel.text = groupName ?? "Cal Poly"
        
        databaseRef = Database.database().reference().child("Groups").child(groupTitleLabel.text!).child("posts")
        
        retrievePosts()
    }

    @IBAction func addPostClicked(_ sender: Any) {
        performSegue(withIdentifier: "addPost", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPost" {
             let destVC = segue.destination as? AddPostViewController
             destVC?.groupName = groupName
             destVC?.header = "Post to Group: " + (groupName ?? "Cal Poly")
        }
        
        else if segue.identifier == "showPostDetail" {
            let destVC = segue.destination as? PostDetailView
            let selectedIndexPath = tableView.indexPathForSelectedRow
            destVC?.groupName = groupName ?? "Cal Poly"
            destVC?.post = messageList[selectedIndexPath!.row]
        }
    }
}

