//
//  MessageCell.swift
//  final_project
//
//  Created by liblabs-mac on 3/2/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import UIKit

class MessageCell : UITableViewCell {
    var upvoted: Bool = false {
        didSet {
            if (upvoted == true) {
                changeArrowColors(upvoteArrow: .red, downvoteArrow: .orange)
            }
            else {
                changeArrowColors(upvoteArrow: .orange, downvoteArrow: .orange)
            }
        }
    }
    
    var downvoted: Bool = false {
        didSet {
            if (downvoted == true) {
                changeArrowColors(upvoteArrow: .orange, downvoteArrow: .red)
            }
            else {
                changeArrowColors(upvoteArrow: .orange, downvoteArrow: .orange)
            }
        }
    }
    
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
            
            changeArrowColors(upvoteArrow: .red, downvoteArrow: .orange)
        }
        
        else {
            let voteCount = Int(voteLabel.text ?? "0")
            voteLabel.text = String(voteCount! - 1)
            
            upvoted = false
            downvoted = false
            
            changeArrowColors(upvoteArrow: .orange, downvoteArrow: .orange)
        }
    }
    
    @IBAction func downvotePressed(_ sender: Any) {
        if !downvoted {
            let voteCount = Int(voteLabel.text ?? "0")
            voteLabel.text = String(voteCount! - (upvoted ? 2 : 1))
            
            downvoted = true
            upvoted = false
            
            changeArrowColors(upvoteArrow: .orange, downvoteArrow: .red)
        }
        
        else {
            let voteCount = Int(voteLabel.text ?? "0")
            voteLabel.text = String(voteCount! + 1)
            
            upvoted = false
            downvoted = false
            
            changeArrowColors(upvoteArrow: .orange, downvoteArrow: .orange)
        }
    }
    
    func changeArrowColors(upvoteArrow lColor: UIColor, downvoteArrow rColor: UIColor) {
        upvoteButton.setTitleColor(lColor, for: .normal)
        downvoteButton.setTitleColor(rColor, for: .normal)
    }
}
