//
//  PostDetailView.swift
//  final_project
//
//  Created by liblabs-mac on 3/2/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import UIKit

class PostDetailView : UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var groupTitleLabel: UILabel!
    @IBOutlet weak var messageContentLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var messageContent: String?
    var groupName: String?
    
    var commentList = ["great post", "bad post"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupTitleLabel.text = "Group: " + (groupName ?? "N/A")
        messageContentLabel.text = "Message:\n" +  (messageContent ?? "N/A")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentCell
        
        let comment = commentList[indexPath.row]
        cell?.commentLabel.text = comment
        
        return cell!
    }
}
