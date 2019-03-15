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
    var dateCreated: NSDate
    
    init(_ content: ARWorldMap) {
        self.content = content
        self.dateCreated = NSDate()
    }
}
