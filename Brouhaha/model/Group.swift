//
//  Group.swift
//  Brouhaha
//
//  Created by Malcolm Craney on 3/2/19.
//  Copyright © 2019 Malcolm Craney. All rights reserved.
//
import Foundation
import FirebaseDatabase

class Group {
    var name: String
    var dateCreated: NSDate
    var subgroups: [Subgroup] = [Subgroup]()
    
    let formatter = DateFormatter()
    
    init(_ name: String) {
        self.name = name
        self.dateCreated = NSDate()

        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    }
    
    init(snapshot: DataSnapshot) {
        let snapvalues = snapshot.value as? [String: AnyObject]
        
        self.name = snapvalues!["name"] as? String ?? "N/A"
        self.subgroups = snapvalues!["subgroups"] as? [Subgroup] ?? []
        let dateCreatedStr = snapvalues!["datecreated"] as? String ?? "n/a"
        self.dateCreated = formatter.date(from: dateCreatedStr) as NSDate? ?? NSDate()
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "dateCreated": formatter.string(from: dateCreated as Date),
            "subgroups": subgroups
        ]
    }
}
