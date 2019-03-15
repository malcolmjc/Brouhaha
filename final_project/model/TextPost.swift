//
//  TextPost.swift
//  final_project
//
//  Created by liblabs-mac on 3/3/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import Foundation
import FirebaseDatabase

class TextPost : NSObject, Codable {
    var content: String
    var voteCount: Int
    var dateCreated: String
    var isUpvoted: Bool?
    var isDownvoted: Bool?
    
    init(_ content: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        self.content = content
        let dateCreated = NSDate()
        self.dateCreated = formatter.string(from: dateCreated as Date)
        self.voteCount = 0
        self.isUpvoted = false
        self.isDownvoted = false
    }
    
    init(snapshot: DataSnapshot) {
        let snapvalues = snapshot.value as! [String : AnyObject]
        
        self.content = snapvalues["content"] as? String ?? "N/A"
        self.dateCreated = snapvalues["dateCreated"] as? String ?? "N/A"
        self.voteCount = snapvalues["voteCount"] as? Int ?? 0
    }
    
    func toAnyObject() -> Any {
        return [
            "content" : content,
            "voteCount": voteCount,
            "dateCreated": dateCreated
        ]
    }
}
