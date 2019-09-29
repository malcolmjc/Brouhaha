//
//  final_projectTests.swift
//  final_projectTests
//
//  Created by liblabs-mac on 3/2/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import XCTest
@testable import final_project

class GroupTests: XCTestCase {
    
    var group: Group!
    var groupName: String = "test name"
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        group = Group(groupName)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        group = nil
    }
    
    func testToAny() {
        let groupAnyObj = group.toAnyObject()
        let groupDict = groupAnyObj as? Dictionary<String, Any>
        
        let name = groupDict!["name"] as! String
        XCTAssert(name == self.groupName)
        
        let date = groupDict!["dateCreated"] as! String
        XCTAssert(date.isEmpty == false)
        
        let subgroups = groupDict!["subgroups"] as! [Subgroup]
        XCTAssert(subgroups.isEmpty == true)
    }
    
    func testToAnyChangeName() {
        let newName = "new name"
        group.name = newName
        
        let groupAnyObj = group.toAnyObject()
        let groupDict = groupAnyObj as? Dictionary<String, Any>
        
        let name = groupDict!["name"] as! String
        XCTAssert(name == newName)
    }
    
    func testToAnyChangeSubgroups() {
        let subgroup = Subgroup("subname", "subdesc")
        let newSubgroups = [subgroup]
        group.subgroups = newSubgroups
        
        let groupAnyObj = group.toAnyObject()
        let groupDict = groupAnyObj as? Dictionary<String, Any>
        
        let subgroups = groupDict!["subgroups"] as! [Subgroup]
        XCTAssert(subgroups[0].name == subgroup.name)
        XCTAssert(subgroups[0].desc == subgroup.desc)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
