//
//  Group.swift
//  final_project
//
//  Created by liblabs-mac on 3/2/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//
import Foundation
import FirebaseDatabase

class Group {
    var name: String
    var desc: String
    var posts: [TextPost] = [TextPost]()
    var dateCreated: NSDate
    
    let formatter = DateFormatter()
    
    init(_ name: String, _ desc: String) {
        self.name = name
        self.desc = desc
        self.dateCreated = NSDate()

        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    init(snapshot: DataSnapshot) {
        let snapvalues = snapshot.value as! [String : AnyObject]
        
        self.name = snapvalues["name"] as? String ?? "N/A"
        self.desc = snapvalues["description"] as? String ?? "n/a"
        self.posts = snapvalues["posts"] as? [TextPost] ?? []
        
        let dateCreatedStr = snapvalues["datecreated"] as? String ?? "n/a"
        self.dateCreated = formatter.date(from: dateCreatedStr) as NSDate? ?? NSDate()
    }
    
    func toAnyObject() -> Any {
        return [
            "name" : name,
            "description" : desc,
            "posts" : posts,
            "dateCreated" : formatter.string(from: dateCreated as Date)
        ]
    }
}
