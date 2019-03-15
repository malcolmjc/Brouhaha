//
//  FirstViewController.swift
//  final_project
//
//  Created by liblabs-mac on 3/2/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var addPost: UIButton!
    
    var groupName: String?
    var messageList = [TextPost("hello"), TextPost("how are you?"), TextPost("wassup"), TextPost("yo")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupTitleLabel.text = groupName ?? "Cal Poly"
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
        self.viewDidLoad()
        tableView.reloadData()
    }

    @IBAction func addPostClicked(_ sender: Any) {
        performSegue(withIdentifier: "addPost", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addPost" {
             let destVC = segue.destination as? AddPostViewController
             destVC?.groupName = groupName
        }
        
        else if segue.identifier == "showPostDetail" {
            let destVC = segue.destination as? PostDetailView
            let selectedIndexPath = tableView.indexPathForSelectedRow
            destVC?.groupName = groupName
            destVC?.post = messageList[selectedIndexPath!.row]
        }
    }
}

