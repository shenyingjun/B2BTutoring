//
//  testSearch.swift
//  B2BTutoring
//
//  Created by 罗阅 on 11/19/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import XCTest

class testSearch: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCancelEditFilter() {
        let app = XCUIApplication()
        app.tabBars.buttons["Search"].tap()
        app.navigationBars["B2BTutoring.SearchTableView"].buttons["Filter"].tap()
        app.navigationBars["B2BTutoring.FilterView"].buttons["Cancel"].tap()
        
    }
    
    func testEditFilter() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        
        app.tabBars.buttons["Search"].tap()
        app.navigationBars["B2BTutoring.SearchTableView"].buttons["Filter"].tap()
        
        tablesQuery.staticTexts["First Name"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier:"First Name").childrenMatchingType(.TextField).element.typeText("Leo")
        app.toolbars.buttons["Done"].tap()
        
        tablesQuery.staticTexts["Last Name"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier:"Last Name").childrenMatchingType(.TextField).element.typeText("Luo")
        app.toolbars.buttons["Done"].tap()
        
        tablesQuery.staticTexts["Rating over"].tap()
        tablesQuery.cells.containingType(.StaticText, identifier:"Rating over").childrenMatchingType(.TextField).element.typeText("3")
        app.toolbars.buttons["Done"].tap()
        
        app.navigationBars["B2BTutoring.FilterView"].buttons["Done"].tap()
        
    }
    
    func testSearchButton() {
        XCUIApplication().navigationBars["B2BTutoring.SearchTableView"].buttons["Search"].tap()
    }
    
    func testEnterSearchText() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        let searchField = tablesQuery.childrenMatchingType(.SearchField).element
        searchField.tap()
        searchField.typeText("Basketball")
        tablesQuery.buttons["Clear text"].tap()
        searchField.typeText("sport")
        app.navigationBars["B2BTutoring.SearchTableView"].buttons["Search"].tap()
    }
    
}
