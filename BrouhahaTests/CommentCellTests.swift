//
//  CommentCellTests.swift
//  BrouhahaTests
//
//  Created by Malcolm Craney on 4/16/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import XCTest
@testable import Brouhaha

class CommentCellTests: XCTestCase {

    var commentCell: CommentCell!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        commentCell = CommentCell()
        commentCell.voteLabel = UILabel()
        commentCell.voteLabel.text = "0"
        commentCell.downvoteButton = UIButton()
        commentCell.upvoteButton = UIButton()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        commentCell = nil
    }

    func testUpvote() {
        XCTAssert(commentCell.voteLabel.text == "0")
        commentCell.upvotePressed(TextPost("doesn't matter"))
        XCTAssert(commentCell.downvoteButton.currentTitleColor == .orange)
        XCTAssert(commentCell.upvoteButton.currentTitleColor == .red)
        XCTAssert(commentCell.upvoted == true)
        XCTAssert(commentCell.downvoted == false)
        XCTAssert(commentCell.voteLabel.text == "1")
    }
    
    func testDownvote() {
        XCTAssert(commentCell.voteLabel.text == "0")
        commentCell.downvotePressed(TextPost("doesn't matter"))
        XCTAssert(commentCell.downvoted == true)
        XCTAssert(commentCell.upvoted == false)
        XCTAssert(commentCell.downvoteButton.currentTitleColor == .red)
        XCTAssert(commentCell.upvoteButton.currentTitleColor == .orange)
        XCTAssert(commentCell.voteLabel.text == "-1")
    }
    
    func testDownvoteThenUpvote() {
        XCTAssert(commentCell.voteLabel.text == "0")
        commentCell.downvotePressed(TextPost("doesn't matter"))
        XCTAssert(commentCell.downvoteButton.currentTitleColor == .red)
        XCTAssert(commentCell.upvoteButton.currentTitleColor == .orange)
        XCTAssert(commentCell.downvoted == true)
        XCTAssert(commentCell.upvoted == false)
        XCTAssert(commentCell.voteLabel.text == "-1")
        
        commentCell.upvotePressed(TextPost("doesn't matter"))
        XCTAssert(commentCell.downvoteButton.currentTitleColor == .orange)
        XCTAssert(commentCell.upvoteButton.currentTitleColor == .red)
        XCTAssert(commentCell.upvoted == true)
        XCTAssert(commentCell.downvoted == false)
        XCTAssert(commentCell.voteLabel.text == "1")
    }
    
    func testUpvoteThenDownvote() {
        XCTAssert(commentCell.voteLabel.text == "0")
        
        commentCell.upvotePressed(TextPost("doesn't matter"))
        XCTAssert(commentCell.downvoteButton.currentTitleColor == .orange)
        XCTAssert(commentCell.upvoteButton.currentTitleColor == .red)
        XCTAssert(commentCell.upvoted == true)
        XCTAssert(commentCell.downvoted == false)
        XCTAssert(commentCell.voteLabel.text == "1")
        
        commentCell.downvotePressed(TextPost("doesn't matter"))
        XCTAssert(commentCell.downvoteButton.currentTitleColor == .red)
        XCTAssert(commentCell.upvoteButton.currentTitleColor == .orange)
        XCTAssert(commentCell.downvoted == true)
        XCTAssert(commentCell.upvoted == false)
        XCTAssert(commentCell.voteLabel.text == "-1")
    }
    
    func testUpvoteThenUpvote() {
        XCTAssert(commentCell.voteLabel.text == "0")
        
        commentCell.upvotePressed(TextPost("doesn't matter"))
        XCTAssert(commentCell.upvoted == true)
        XCTAssert(commentCell.downvoted == false)
        XCTAssert(commentCell.voteLabel.text == "1")
        
        commentCell.upvotePressed(TextPost("doesn't matter"))
        XCTAssert(commentCell.upvoted == false)
        XCTAssert(commentCell.downvoted == false)
        XCTAssert(commentCell.voteLabel.text == "0")
    }
    
    func testDownvoteThenDownvote() {
        XCTAssert(commentCell.voteLabel.text == "0")
        
        commentCell.downvotePressed(TextPost("doesn't matter"))
        XCTAssert(commentCell.downvoteButton.currentTitleColor == .red)
        XCTAssert(commentCell.upvoteButton.currentTitleColor == .orange)
        XCTAssert(commentCell.upvoted == false)
        XCTAssert(commentCell.downvoted == true)
        XCTAssert(commentCell.voteLabel.text == "-1")
        
        commentCell.downvotePressed(TextPost("doesn't matter"))
        XCTAssert(commentCell.downvoteButton.currentTitleColor == .orange)
        XCTAssert(commentCell.upvoteButton.currentTitleColor == .orange)
        XCTAssert(commentCell.upvoted == false)
        XCTAssert(commentCell.downvoted == false)
        XCTAssert(commentCell.voteLabel.text == "0")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
