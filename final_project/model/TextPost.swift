//
//  TextPost.swift
//  final_project
//
//  Created by liblabs-mac on 3/3/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import Foundation
import FirebaseDatabase

class TextPost : NSObject {
    var content: String
    var voteCount: Int
    var dateCreated: String
    
    let formatter = DateFormatter()
    
    init(_ content: String) {
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        self.content = content
        let dateCreated = NSDate()
        self.dateCreated = formatter.string(from: dateCreated as Date)
        self.voteCount = 0
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
