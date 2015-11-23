//
//  testCreateSession.swift
//  B2BTutoring
//
//  Created by 罗阅 on 11/19/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import XCTest

class testCreateSession: XCTestCase {
        
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
    
    func testCancelSessionCreation() {
        let app = XCUIApplication()
        let navBar = app.navigationBars["B2BTutoring.SessionTableView"]
        let tutorButton = navBar.buttons["Tutor"]
        tutorButton.tap()
        navBar.buttons["add session"].tap()
        app.navigationBars["B2BTutoring.CreateSessionView"].buttons["Cancel"].tap()
        
        XCTAssert(navBar.buttons["add session"].exists)
        
        
    }
    
    func testAddSession() {
        let app = XCUIApplication()
        app.launchEnvironment = ["AutoCorrection": "Disabled"]
        
        let navBar = app.navigationBars["B2BTutoring.SessionTableView"]
        navBar.buttons["Tutor"].tap()
        XCTAssert(navBar.buttons["add session"].enabled) //tutor can add session
        
        navBar.buttons["add session"].tap()
        
        XCTAssertNotNil(navBar.buttons["Post"])  //should enter the post session page
        
        let tablesQuery = app.tables
        
        //test input to title field
        let title = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(0).childrenMatchingType(.TextField).element
        title.tap()
        title.typeText("CS130 Project")
        XCTAssertEqual((title.value as! String), "CS130 Project")
        
        //test input to location field
        let location = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(1).childrenMatchingType(.TextField).element
        location.tap()
        location.typeText("Boelter Hall 8th floor")
        XCTAssertEqual((location.value as! String), "Boelter Hall 8th floor")
        
        //test input to tags field
        let tags = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(3).childrenMatchingType(.TextField).element
        tags.tap()
        tags.typeText("#programming")
        XCTAssertEqual((tags.value as! String), "#programming")
        
        //test input to Category. This test is a black-box test
        tablesQuery.staticTexts["Category"].tap()
        app.pickerWheels.element.adjustToPickerWheelValue("DIY_and_crafts")
        
        //test input to capacity
        let capacity = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(4).childrenMatchingType(.TextField).element
        capacity.tap()
        capacity.tap()
        capacity.typeText("8")
        XCTAssertEqual((capacity.value as! String), "8")
        
        
        //test input to Description field
        //due to the stupid auto-correction, some text input might not work and this is not the app's problem
        let textView = tablesQuery.cells.containingType(.StaticText, identifier:"Description").childrenMatchingType(.TextView).element
        textView.tap()
        textView.typeText("CS130 Project")
        XCTAssertEqual((textView.value as! String).lowercaseString, "cs130 project")
        
        //
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
