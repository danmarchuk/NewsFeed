//
//  NewsFeedUITests.swift
//  NewsFeedUITests
//
//  Created by Данік on 09/08/2023.
//

import XCTest


class NewsFeedUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launch()
    }

    func testNewsFeedInteractions() throws {
//         Tap on the first cell
        let firstCell = app.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "Failed to load the first cell in time.")
        
        // Define the start and end points for the swipe
        let start = app.windows.element(boundBy: 0).coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        let end = app.windows.element(boundBy: 0).coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))

        // Perform the swipe
        start.press(forDuration: 0.3, thenDragTo: end)
        
        XCTAssertTrue(firstCell.waitForExistence(timeout: 10), "Failed to load the first cell in time.")

        firstCell.tap()

        // Go back
        let backButton = app.navigationBars.buttons["backArrowButton"]
        backButton.tap()

        // Tap on the second cell
        let secondCell = app.cells.element(boundBy: 1)
        secondCell.tap()

        // Tap on the bookmark bar button
        let bookmarkButton = app.navigationBars.buttons["bookmarkButton"]
        bookmarkButton.tap()

        // Go back
        backButton.tap()

        // Swipe up
        app.swipeUp()
        app.swipeUp()

        // Tap on the third cell
        let thirdCell = app.cells.element(boundBy: 2)
        thirdCell.tap()

        // Click on the read in source button
        let readInSourceButton = app.buttons["readInSourceButton"]
        readInSourceButton.tap()

        // Close the WebView
        let xButton = app.buttons["xButton"]
        xButton.tap()

        // Go back
        backButton.tap()

        let firstTab = app.tabBars.buttons.element(boundBy: 0)
        let secondTab = app.tabBars.buttons.element(boundBy: 1)
        let thirdTab = app.tabBars.buttons.element(boundBy: 2)
        let fourthTab = app.tabBars.buttons.element(boundBy: 3)

        secondTab.tap()
        thirdTab.tap()
        fourthTab.tap()

        firstTab.tap()
        app.swipeDown()
        app.swipeDown()
        app.swipeDown()
        app.swipeDown()

        // Perform the swipe
        start.press(forDuration: 0.3, thenDragTo: end)
    }
}

