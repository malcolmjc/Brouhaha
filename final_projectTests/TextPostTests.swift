//
//  TextPostTests.swift
//  final_projectTests
//
//  Created by Malcolm Craney on 4/16/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import XCTest
@testable import final_project

class TextPostTests: XCTestCase {
    var textPost: TextPost!
    var content = "test content"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
      textPost = TextPost(content)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
      textPost = nil
    }

    func testToAny() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let textAnyObj = textPost.toAnyObject()
        let textDict = textAnyObj as? Dictionary<String, Any>

        let content = textDict!["content"] as! String
        XCTAssert(content == self.content)

        let votes = textDict!["voteCount"] as! Int
        XCTAssert(votes == 0)

        let date = textDict!["dateCreated"] as! String
        XCTAssert(date.isEmpty == false)
   
        XCTAssert(textPost.isDownvoted == false)
        XCTAssert(textPost.isUpvoted == false)
    }
   
    func testToAny2() {
        let newContent = "new content"
        textPost.content = newContent
      
        let textAnyObj = textPost.toAnyObject()
        let textDict = textAnyObj as? Dictionary<String, Any>
      
        let content = textDict!["content"] as! String
        XCTAssert(content == newContent)
      
        let votes = textDict!["voteCount"] as! Int
        XCTAssert(votes == 0)
      
        let date = textDict!["dateCreated"] as! String
        XCTAssert(date.isEmpty == false)
      
        XCTAssert(textPost.isDownvoted == false)
        XCTAssert(textPost.isUpvoted == false)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
