//
//  FirstViewController.swift
//  final_project
//
//  Created by Malcolm Craney on 3/2/19.
//  Copyright © 2019 Malcolm Craney. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import MJRefresh

class PostsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var addPost: UIButton!
    
    var groupName: String?
    var messageList = [TextPost]()
    var cellList = [MessageCell?]()
    
    //Codable persistence stuff
    static let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let archiveURL = documentsDirectory.appendingPathComponent("savedPosts")
    var ourDefaults = UserDefaults.standard
    var dateFormatter = DateFormatter()
    var superGroup = ""
    
    var databaseRef: DatabaseReference!
    
    func setupAutoDimensionTable() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 64
        tableView.separatorColor = UIColor(red: 0.76, green: 0.55, blue: 0.62, alpha: 1.0)
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self,
                                                         refreshingAction: #selector(PostsViewController.refreshPosts))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupTitleLabel.text = groupName ?? "students"
        
        /*databaseRef = Database.database().reference().child("Groups")
            .child(superGroup).child("subgroups").child(groupTitleLabel.text!)*/
        
        databaseRef = Database.database().reference().child("Groups")
            .child(groupTitleLabel.text!).child("posts")
        
        setupAutoDimensionTable()
        
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        retrievePosts()
    }
    
    func getLastUpdate() {
        if let lastUpdate = ourDefaults.object(forKey: "lastUpdate") as? Date {
            let groupArchiveURL = PostsViewController.documentsDirectory.appendingPathComponent("savedPosts" +
                ((groupName ?? "Cal Poly").replacingOccurrences(of: " ", with: "")))
            
            do {
                let data = try Data(contentsOf: groupArchiveURL)
                let decoder = JSONDecoder()
                let tempArr = try decoder.decode([TextPost].self, from: data)
                
                var idx = 0
                for textPost in tempArr {
                    if let upv = textPost.isUpvoted {
                        if upv {
                            messageList[idx].isUpvoted = true
                            messageList[idx].isDownvoted = false
                        }
                    }
                    
                    if let downv = textPost.isDownvoted {
                        if downv {
                            messageList[idx].isDownvoted = true
                            messageList[idx].isUpvoted = false
                        }
                    }
                    
                    idx += 1
                }
               
            } catch {
                print(error)
            }
        }
    }
    
    func updatePersistentStorage() {
        //find out if a post has been upvoted/downvoted by user
        var idx = 0
        for cell in cellList {
            if let cell = cell {
                if cell.upvoted {
                    messageList[idx].isUpvoted = true
                    messageList[idx].isDownvoted = false
                } else if cell.downvoted {
                    messageList[idx].isDownvoted = true
                    messageList[idx].isUpvoted = false
                } else {
                    messageList[idx].isDownvoted = false
                    messageList[idx].isUpvoted = false
                }
            }
            
            idx += 1
        }
        
        let groupArchiveURL = PostsViewController.documentsDirectory
                                .appendingPathComponent("savedPosts" + ((groupName ?? "Cal Poly")
                                .replacingOccurrences(of: " ", with: "")))
        
        // persist data
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(messageList)
            try jsonData.write(to: groupArchiveURL)
            
            // timestamp last update
            ourDefaults.set(Date(), forKey: "lastUpdate")
            
        } catch {
            print(error)
        }
    }
    
    @IBAction func refreshPosts() {
        retrievePosts()
        self.tableView.mj_header.endRefreshing()
    }
    
    @IBAction func retrievePosts() {
        self.messageList = []
        self.cellList = []
        
        databaseRef?.queryOrdered(byChild: "posts")
            .observe(.value, with: { snapshot in
                self.messageList = []
                self.cellList = []
                
                for item in snapshot.children {
                    let actItem = item as? DataSnapshot
                    self.messageList.append(TextPost(snapshot: actItem!))
                    self.cellList.append(nil)
                }
                
                //get if posts have been updated by the user
                self.getLastUpdate()
                self.tableView.reloadData()
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return messageList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell
        
        if indexPath.section >= messageList.count {
            return cell!
        }
        
        cell!.downvoted = false
        cell!.upvoted = false
        
        let message = messageList[indexPath.section]
        cellList[indexPath.section] = cell
        
        cell?.messageLabel.text = message.content
        
        if let down = message.isDownvoted {
            if down {
                cell!.downvoted = true
            }
        }
        
        if let upv = message.isUpvoted {
            if upv {
                cell!.upvoted = true
            }
        }
    
        cell?.voteLabel.text = String(message.voteCount)
        
        cell?.layer.cornerRadius = 25
        cell?.layer.masksToBounds = true
        
        return cell!
    }
    
    var subgroupName = ""
    @IBAction func unwindToPosts(segue: UIStoryboardSegue) {
        groupTitleLabel.text = subgroupName
        
        databaseRef = Database.database().reference().child("Groups").child(groupName!).child("subgroups").child(subgroupName).child("posts")
        
        retrievePosts()
    }

    @IBAction func addPostClicked(_ sender: Any) {
        performSegue(withIdentifier: "addPost", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPost" {
             let destVC = segue.destination as? AddPostViewController
             destVC?.groupName = groupName
             destVC?.subgroupName = subgroupName
             destVC?.header = "Post to Group: " + (groupName ?? "Cal Poly")
        } else if segue.identifier == "showPostDetail" {
            let destVC = segue.destination as? PostDetailView
            let selectedIndexPath = tableView.indexPathForSelectedRow
            destVC?.groupName = groupName ?? "Cal Poly"
            destVC?.post = messageList[selectedIndexPath!.section]
        }
    }
    
    func updateVoteCount(_ dateCreated: String, _ newVoteCount: Int) {
        let postRef = databaseRef.child(dateCreated).child("voteCount")
        postRef.setValue(newVoteCount)
    }
    
    func updateVoteCounts() {
        //find out if a post has been upvoted/downvoted by user
        var idx = 0
        for cell in cellList {
            if let cell = cell {
                //the user has changed their upvote/downvote, need to update firebase
                if messageList[idx].isUpvoted == nil || messageList[idx].isDownvoted == nil
                   || cell.upvoted != messageList[idx].isUpvoted! || cell.downvoted != messageList[idx].isDownvoted! {
                    updateVoteCount(messageList[idx].dateCreated, Int(cell.voteLabel.text!)!)
                }
            }
            
            idx += 1
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        updateVoteCounts()
        updatePersistentStorage()
    }
}
