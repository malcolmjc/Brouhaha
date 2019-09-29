//
//  AddPostUITests.swift
//  BrouhahaUITests
//
//  Created by Lindsey Piggott on 4/17/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import XCTest

class AddPostUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddNewPost() {
        let cells = XCUIApplication().tables.cells
        let cellCount = cells.count
        
        let app = XCUIApplication()
        app.buttons["+"].tap()
        let textView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        
        textView.tap()
        textView.typeText("New post")
        
        app.buttons["Submit"].tap()
        
        let newCells = XCUIApplication().tables.cells
        let newCellCount = newCells.count
        
        XCTAssert(newCellCount == cellCount + 1)
    }
    
    func testCancelAddNewPost() {
        let cells = XCUIApplication().tables.cells
        let cellCount = cells.count
        
        let app = XCUIApplication()
        app.buttons["+"].tap()
        let textView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element
        
        textView.tap()
        textView.typeText("New post")
        
        app.buttons["Cancel"].tap()
        
        let newCells = XCUIApplication().tables.cells
        let newCellCount = newCells.count
        
        XCTAssert(newCellCount == cellCount)
    }
}
