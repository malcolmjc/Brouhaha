//
//  ARPost.swift
//  final_project
//
//  Created by liblabs-mac on 3/3/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import Foundation
import ARKit

class ARPost {
    var content: ARWorldMap
    //var data: Data
    var dateCreated: String
    
    init(_ content: ARWorldMap) throws {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        self.content = content
        //self.data = try NSKeyedArchiver.archivedData(withRootObject: content, requiringSecureCoding: true)
        
        let dateCreated = NSDate()
        self.dateCreated = formatter.string(from: dateCreated as Date)
    }
    
    func toAnyObject() -> Any {
        return [
            //"content" : content,
            "dateCreated": dateCreated
        ]
    }
}
