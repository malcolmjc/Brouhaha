//
//  MessageCell.swift
//  final_project
//
//  Created by liblabs-mac on 3/2/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import UIKit

class MessageCell : UITableViewCell {
    var upvoted: Bool = false
    var downvoted: Bool = false
    
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var downvoteButton: UIButton!
    
    @IBAction func upvotePressed(_ sender: Any) {
        if !upvoted {
            let voteCount = Int(voteLabel.text ?? "0")
            voteLabel.text = String(voteCount! + (downvoted ? 2 : 1))
            
            upvoted = true
            downvoted = false
            
            upvoteButton.setTitleColor(.red, for: .normal)
            downvoteButton.setTitleColor(.orange, for: .normal)
        }
        
        else {
            let voteCount = Int(voteLabel.text ?? "0")
            voteLabel.text = String(voteCount! - 1)
            
            upvoted = false
            downvoted = false
            
            upvoteButton.setTitleColor(.orange, for: .normal)
            downvoteButton.setTitleColor(.orange, for: .normal)
        }
    }
    
    @IBAction func downvotePressed(_ sender: Any) {
        if !downvoted {
            let voteCount = Int(voteLabel.text ?? "0")
            voteLabel.text = String(voteCount! - (upvoted ? 2 : 1))
            
            downvoted = true
            upvoted = false
            
            downvoteButton.setTitleColor(.red, for: .normal)
            upvoteButton.setTitleColor(.orange, for: .normal)
        }
        
        else {
            let voteCount = Int(voteLabel.text ?? "0")
            voteLabel.text = String(voteCount! + 1)
            
            upvoted = false
            downvoted = false
            
            upvoteButton.setTitleColor(.orange, for: .normal)
            downvoteButton.setTitleColor(.orange, for: .normal)
        }
    }
}
