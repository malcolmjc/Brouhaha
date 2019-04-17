//
//  final_projectTests.swift
//  final_projectTests
//
//  Created by liblabs-mac on 3/2/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import XCTest
@testable import final_project

class final_projectTests: XCTestCase {
   
   var group: Group!
   var desc: String = "test description"
   var name_: String = "test name"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      group = Group(name_, desc)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      group = nil
    }

    func testToAny() {
      let groupAnyObj = group.toAnyObject()
      let groupDict = groupAnyObj as? Dictionary<String, Any>

      let desc = groupDict!["description"] as! String
      XCTAssert(desc == self.desc)
      
      let name = groupDict!["name"] as! String
      XCTAssert(name == self.name)
      
      let date = groupDict!["dateCreated"] as! String
      XCTAssert(date.isEmpty == false)
   }
   
   func testToAny2() {
      let newDesc = "new desc"
      let newName = "new name"
      group.desc = newDesc
      group.name = newName
      
      let groupAnyObj = group.toAnyObject()
      let groupDict = groupAnyObj as? Dictionary<String, Any>
      
      let desc = groupDict!["description"] as! String
      XCTAssert(desc == newDesc)
      
      let name = groupDict!["name"] as! String
      XCTAssert(name == newName)
      
      let date = groupDict!["dateCreated"] as! String
      XCTAssert(date.isEmpty == false)
   }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
