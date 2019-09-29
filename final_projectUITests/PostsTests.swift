//
//  final_projectUITests.swift
//  final_projectUITests
//
//  Created by liblabs-mac on 3/2/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import XCTest

class final_projectUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetPostDetailMessagesMatch() {
        let cells = XCUIApplication().tables.cells
        XCTAssert(cells.count > 0)
        let chosenCell = cells.element(boundBy: 0)

        let cellText = chosenCell.staticTexts.element(matching: .any,
                                                      identifier: "testMessageLabel").label

        chosenCell.tap()
        
        let detailText = app.staticTexts.element(matching: .any,
                                                 identifier: "testMessageContent").label
        
        var detailTextArr = detailText.components(separatedBy: "\n")
        
        XCTAssert(detailTextArr[0] == "Message:")

        XCTAssert(cellText == detailTextArr[1])
    }
    
    func testGetPostDetailVotesMatch() {
        let cells = XCUIApplication().tables.cells
        XCTAssert(cells.count > 0)
        let chosenCell = cells.element(boundBy: 0)
        
        let cellVote = chosenCell.staticTexts.element(matching: .any,
                                                      identifier: "testMessageVoteCount").label
        
        chosenCell.tap()
        
        //TODO: Start including vote count in message detail
        //let detailVote = app.staticTexts.element(matching: .any, identifier: "testDetailVoteCount").label
        
        //XCTAssert(cellVote == detailVote)
    }
    
    func testUpvotePost() {
        let cells = XCUIApplication().tables.cells
        XCTAssert(cells.count > 0)
        let chosenCell = cells.element(boundBy: 0)
        
        let cellVoteCount = chosenCell.staticTexts.element(matching: .any,
                                                      identifier: "testMessageVoteCount").label
        
        chosenCell.buttons.element(matching: .any,
                        identifier: "messageUpvote").tap()
        
        let newCellVoteCount = chosenCell.staticTexts.element(matching: .any,
                                                      identifier: "testMessageVoteCount").label
        
        XCTAssert((Int(cellVoteCount)! + 1) == Int(newCellVoteCount)!)
    }
    
    func testDownvotePost() {
        let cells = XCUIApplication().tables.cells
        XCTAssert(cells.count > 0)
        let chosenCell = cells.element(boundBy: 0)
        
        let cellVoteCount = chosenCell.staticTexts.element(matching: .any,
                                                           identifier: "testMessageVoteCount").label
        
        chosenCell.buttons.element(matching: .any,
                                   identifier: "messageDownvote").tap()
        
        let newCellVoteCount = chosenCell.staticTexts.element(matching: .any,
                                                              identifier: "testMessageVoteCount").label
        
        XCTAssert((Int(cellVoteCount)! - 1) == Int(newCellVoteCount)!)
    }
}
