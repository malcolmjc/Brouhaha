//
//  ARViewUITests.swift
//  BrouhahaUITests
//
//  Created by Lindsey Piggott on 4/17/19.
//  Copyright © 2019 liblabs-mac. All rights reserved.
//

import XCTest

class ARViewUITests: XCTestCase {

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

    func testChangePaint() {
        let app = XCUIApplication()
        app.tabBars.buttons["AR"].tap()
        app.buttons["camera"].tap()
        XCTAssert(app.buttons["PinClipart"].exists)
        XCTAssert(app.buttons["plane"].exists == false)
        XCTAssert(app.buttons["torus"].exists == false)
        XCTAssert(app.buttons["cube"].exists == false)
        XCTAssert(app.buttons["pyramid"].exists == false)
        XCTAssert(app.buttons["sphere"].exists == false)

        app.buttons["Edit"].tap()
        XCTAssert(app.buttons["PinClipart"].exists == false)
        XCTAssert(app.buttons["plane"].exists)
        XCTAssert(app.buttons["torus"].exists)
        XCTAssert(app.buttons["cube"].exists)
        XCTAssert(app.buttons["pyramid"].exists)
        XCTAssert(app.buttons["sphere"].exists)
    }

}
