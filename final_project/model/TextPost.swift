//
//  TextPost.swift
//  final_project
//
//  Created by Malcolm Craney on 3/3/19.
//  Copyright © 2019 Malcolm Craney. All rights reserved.
//

import Foundation
import FirebaseDatabase

class TextPost: NSObject, Codable {
    var content: String
    var voteCount: Int
    var dateCreated: String
    var isUpvoted: Bool?
    var isDownvoted: Bool?
    
    //if initialized with this constructor then the user just created a new post
    init(_ content: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        self.content = content
        let dateCreated = NSDate()
        self.dateCreated = formatter.string(from: dateCreated as Date)
        self.voteCount = 0
        
        //when the user first creates a post it is neither updated nor downvoted
        self.isUpvoted = false
        self.isDownvoted = false
    }
    
    //otherwise it is being retrieved from the database
    init(snapshot: DataSnapshot) {
        let snapvalues = snapshot.value as? [String: AnyObject]
        
        self.content = snapvalues!["content"] as? String ?? "N/A"
        self.dateCreated = snapvalues!["dateCreated"] as? String ?? "N/A"
        self.voteCount = snapvalues!["voteCount"] as? Int ?? 0
        
        //we can't update isUpvoted and isDownvoted because it is not stored within db
        //it is instead stored locally with Codable
    }
    
    func toAnyObject() -> Any {
        return [
            "content": content,
            "voteCount": voteCount,
            "dateCreated": dateCreated
        ]
    }
}
