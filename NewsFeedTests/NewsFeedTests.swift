//
//  NewsFeedTests.swift
//  NewsFeedTests
//
//  Created by Данік on 09/08/2023.
//

import XCTest
@testable import NewsFeed

final class NewsFeedTests: XCTestCase {
    
    // MARK: - iso8601StringToDate Tests
    func testIso8601StringToDate_ValidString_ReturnsDate() {
        let dateString = "2023-08-13T12:00:00Z"
        let date = FuncManager.iso8601StringToDate(dateString)
        XCTAssertNotNil(date, "Expected a valid date from ISO 8601 string.")
    }
    
    func testIso8601StringToDate_InvalidString_ReturnsNil() {
        let dateString = "13/08/2023 12:00:00"
        let date = FuncManager.iso8601StringToDate(dateString)
        XCTAssertNil(date, "Expected nil from invalid ISO 8601 string.")
    }
    
    // MARK: - convertToDate Tests
    func testConvertToDate_ValidString_ReturnsNil() {
        let dateString = "2023-08-21T11:10:21-04:00"
        let date = FuncManager.convertToDate(from: dateString)
        XCTAssertNil(date, "Expected nil from invalid string format.")
    }
    
    func testConvertToDate_InvalidString_ReturnsDate() {
        let dateString = "Sun, 13 Aug 2023 12:00:00 +0000"
        let date = FuncManager.convertToDate(from: dateString)
        XCTAssertNil(date, "Expected a valid date from string.")
    }
    
    // MARK: - timeAgoString Tests
    func testTimeAgoString_DaysDifference_ReturnsCorrectString() {
        let oldDate = Date(timeIntervalSinceNow: -5*24*60*60) // 5 days ago
        let currentDate = Date()
        let timeAgo = FuncManager.timeAgoString(from: oldDate, to: currentDate)
        XCTAssertEqual(timeAgo, "5 days ago", "Expected '5 days ago' but got \(timeAgo).")
    }
    
    func testTimeAgoString_HoursDifference_ReturnsCorrectString() {
        let oldDate = Date(timeIntervalSinceNow: -3*60*60) // 3 hours ago
        let currentDate = Date()
        let timeAgo = FuncManager.timeAgoString(from: oldDate, to: currentDate)
        XCTAssertEqual(timeAgo, "3 hours ago", "Expected '3 hours ago' but got \(timeAgo).")
    }
}

