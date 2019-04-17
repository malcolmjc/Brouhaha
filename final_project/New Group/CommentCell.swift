//
//  CommentCell.swift
//  final_project
//
//  Created by liblabs-mac on 3/2/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet var voteLabel: UILabel!
    
    @IBOutlet var upvoteButton: UIButton!
    @IBOutlet var downvoteButton: UIButton!

    var upvoted: Bool = false {
        didSet {
            if upvoted == true {
                changeArrowColors(upvoteArrow: .red, downvoteArrow: .orange)
            } else if !downvoted {
                changeArrowColors(upvoteArrow: .orange, downvoteArrow: .orange)
            }
        }
    }
    
    var downvoted: Bool = false {
        didSet {
            if downvoted == true {
                changeArrowColors(upvoteArrow: .orange, downvoteArrow: .red)
            } else if !upvoted {
                changeArrowColors(upvoteArrow: .orange, downvoteArrow: .orange)
            }
        }
    }
    
    func updateCellAttributes(isUpvote: Bool) {
        if (downvoted && !isUpvote) || (upvoted && isUpvote) {
            let voteCount = Int(voteLabel.text ?? "0")
            let toAdd = isUpvote ? -1 : 1
            voteLabel.text = String(voteCount! + toAdd)
            
            upvoted = false
            downvoted = false
        } else {
            let voteCount = Int(voteLabel.text ?? "0")
            var toAdd: Int
            if !isUpvote {
                toAdd = upvoted ? -2 : -1
            }
            else {
                toAdd = downvoted ? 2 : 1
            }
            voteLabel.text = String(voteCount! + toAdd)
            
            downvoted = !isUpvote
            upvoted = isUpvote
        }
    }
    
    @IBAction func upvotePressed(_ sender: Any) {
        updateCellAttributes(isUpvote: true)
    }
    
    @IBAction func downvotePressed(_ sender: Any) {
        updateCellAttributes(isUpvote: false)
    }
    
    func changeArrowColors(upvoteArrow lColor: UIColor, downvoteArrow rColor: UIColor) {
        upvoteButton.setTitleColor(lColor, for: .normal)
        downvoteButton.setTitleColor(rColor, for: .normal)
    }
}
