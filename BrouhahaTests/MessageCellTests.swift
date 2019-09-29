//
//  MessageCellTests.swift
//  BrouhahaTests
//
//  Created by Malcolm Craney on 4/16/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import XCTest
@testable import Brouhaha

class MessageCellTests: XCTestCase {

    var messageCell: MessageCell!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        messageCell = MessageCell()
        messageCell.voteLabel = UILabel()
        messageCell.voteLabel.text = "0"
        messageCell.downvoteButton = UIButton()
        messageCell.upvoteButton = UIButton()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        messageCell = nil
    }
    
    func testUpvote() {
        XCTAssert(messageCell.voteLabel.text == "0")
        messageCell.upvotePressed(TextPost("doesn't matter"))
        XCTAssert(messageCell.downvoteButton.currentTitleColor == .orange)
        XCTAssert(messageCell.upvoteButton.currentTitleColor == .red)
        XCTAssert(messageCell.upvoted == true)
        XCTAssert(messageCell.downvoted == false)
        XCTAssert(messageCell.voteLabel.text == "1")
    }
    
    func testDownvote() {
        XCTAssert(messageCell.voteLabel.text == "0")
        messageCell.downvotePressed(TextPost("doesn't matter"))
        XCTAssert(messageCell.downvoted == true)
        XCTAssert(messageCell.upvoted == false)
        XCTAssert(messageCell.downvoteButton.currentTitleColor == .red)
        XCTAssert(messageCell.upvoteButton.currentTitleColor == .orange)
        XCTAssert(messageCell.voteLabel.text == "-1")
    }
    
    func testDownvoteThenUpvote() {
        XCTAssert(messageCell.voteLabel.text == "0")
        messageCell.downvotePressed(TextPost("doesn't matter"))
        XCTAssert(messageCell.downvoteButton.currentTitleColor == .red)
        XCTAssert(messageCell.upvoteButton.currentTitleColor == .orange)
        XCTAssert(messageCell.downvoted == true)
        XCTAssert(messageCell.upvoted == false)
        XCTAssert(messageCell.voteLabel.text == "-1")
        
        messageCell.upvotePressed(TextPost("doesn't matter"))
        XCTAssert(messageCell.downvoteButton.currentTitleColor == .orange)
        XCTAssert(messageCell.upvoteButton.currentTitleColor == .red)
        XCTAssert(messageCell.upvoted == true)
        XCTAssert(messageCell.downvoted == false)
        XCTAssert(messageCell.voteLabel.text == "1")
    }
    
    func testUpvoteThenDownvote() {
        XCTAssert(messageCell.voteLabel.text == "0")
        
        messageCell.upvotePressed(TextPost("doesn't matter"))
        XCTAssert(messageCell.downvoteButton.currentTitleColor == .orange)
        XCTAssert(messageCell.upvoteButton.currentTitleColor == .red)
        XCTAssert(messageCell.upvoted == true)
        XCTAssert(messageCell.downvoted == false)
        XCTAssert(messageCell.voteLabel.text == "1")
        
        messageCell.downvotePressed(TextPost("doesn't matter"))
        XCTAssert(messageCell.downvoteButton.currentTitleColor == .red)
        XCTAssert(messageCell.upvoteButton.currentTitleColor == .orange)
        XCTAssert(messageCell.downvoted == true)
        XCTAssert(messageCell.upvoted == false)
        XCTAssert(messageCell.voteLabel.text == "-1")
    }
    
    func testUpvoteThenUpvote() {
        XCTAssert(messageCell.voteLabel.text == "0")
        
        messageCell.upvotePressed(TextPost("doesn't matter"))
        XCTAssert(messageCell.upvoted == true)
        XCTAssert(messageCell.downvoted == false)
        XCTAssert(messageCell.voteLabel.text == "1")
        
        messageCell.upvotePressed(TextPost("doesn't matter"))
        XCTAssert(messageCell.upvoted == false)
        XCTAssert(messageCell.downvoted == false)
        XCTAssert(messageCell.voteLabel.text == "0")
    }
    
    func testDownvoteThenDownvote() {
        XCTAssert(messageCell.voteLabel.text == "0")
        
        messageCell.downvotePressed(TextPost("doesn't matter"))
        XCTAssert(messageCell.downvoteButton.currentTitleColor == .red)
        XCTAssert(messageCell.upvoteButton.currentTitleColor == .orange)
        XCTAssert(messageCell.upvoted == false)
        XCTAssert(messageCell.downvoted == true)
        XCTAssert(messageCell.voteLabel.text == "-1")
        
        messageCell.downvotePressed(TextPost("doesn't matter"))
        XCTAssert(messageCell.downvoteButton.currentTitleColor == .orange)
        XCTAssert(messageCell.upvoteButton.currentTitleColor == .orange)
        XCTAssert(messageCell.upvoted == false)
        XCTAssert(messageCell.downvoted == false)
        XCTAssert(messageCell.voteLabel.text == "0")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
