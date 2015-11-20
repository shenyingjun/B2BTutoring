//
//  testProfile.swift
//  B2BTutoring
//
//  Created by 罗阅 on 11/19/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import XCTest

class testProfile: XCTestCase {
        
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
    
    func testTuteeProfile(){
        let app = XCUIApplication()
        app.tabBars.buttons["Profile"].tap()
        
        app.navigationBars["B2BTutoring.ProfileTableView"].buttons["Tutee"].tap()
        //test edit button is disabled
        XCTAssertFalse(app.navigationBars["B2BTutoring.ProfileTableView"].childrenMatchingType(.Button).elementBoundByIndex(1).enabled)
        
    }
    
    func testTutorProfile(){
        
        let app = XCUIApplication()
        app.tabBars.buttons["Profile"].tap()
        
        app.navigationBars["B2BTutoring.ProfileTableView"].buttons["Tutor"].tap()
        
        //test edit button is disabled
        XCTAssertFalse(app.navigationBars["B2BTutoring.ProfileTableView"].childrenMatchingType(.Button).elementBoundByIndex(1).enabled)
        
        //test press More button
        let moreButton = app.tables.cells.staticTexts["More"]
        XCTAssert(moreButton.exists)
        moreButton.tap()
        
        //test press Back button
        let backButton = app.navigationBars["B2BTutoring.ReviewTableView"].childrenMatchingType(.Button).matchingIdentifier("Back").elementBoundByIndex(0)
        XCTAssert(backButton.exists)
        backButton.tap()
        
    }
    
    func testCancelEditProfile(){
        let app = XCUIApplication()
        app.tabBars.buttons["Profile"].tap()
        app.navigationBars["B2BTutoring.ProfileTableView"].childrenMatchingType(.Button).elementBoundByIndex(1).tap()
        XCTAssert(app.navigationBars["B2BTutoring.EditProfileView"].exists) //test if we are under EditProfileView
        app.navigationBars["B2BTutoring.EditProfileView"].buttons["Cancel"].tap()
        XCTAssertFalse(app.navigationBars["B2BTutoring.EditProfileView"].exists)
    }
    
    func testEditProfile(){
        
        let app = XCUIApplication()
        app.tabBars.buttons["Profile"].tap()
        app.navigationBars["B2BTutoring.ProfileTableView"].buttons["edit"].tap()
        
        let tablesQuery = app.tables
        
        
        let firstName = tablesQuery.cells.containingType(.StaticText, identifier:"First Name").childrenMatchingType(.TextField).element
        firstName.clearAndEnterText("Leo")
        
        let lastName = tablesQuery.cells.containingType(.StaticText, identifier:"Last Name").childrenMatchingType(.TextField).element
        lastName.clearAndEnterText("Luo")
        
        let emailAddress = tablesQuery.cells.containingType(.StaticText, identifier: "Email").childrenMatchingType(.TextField).element
        emailAddress.clearAndEnterText("leoyue94@gmail.com")
        
        //To prevent confusion we decide not to change the password
        /*let pwd = tablesQuery.cells.containingType(.StaticText, identifier: "Password").childrenMatchingType(.TextField).element
        pwd.clearAndEnterText("123456")*/
        
        //Test one of the interest fields is enough
        let tag = tablesQuery.cells.containingType(.StaticText, identifier:"Tag").childrenMatchingType(.TextField).elementBoundByIndex(0)
        tag.clearAndEnterText("#play guitar")
        app.toolbars.buttons["Done"].tap()
        
        let categ = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(7)
        categ.tap()
        app.pickerWheels.element.adjustToPickerWheelValue("Music")
        categ.staticTexts["Music"].tap()
        
        app.swipeUp()
        
        let textView = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(12).childrenMatchingType(.TextView).element
        
        textView.pressForDuration(1.4);
        app.menuItems["Select All"].tap()
        textView.typeText("\u{8}")
        textView.typeText("I am a CS nerd.")
        app.toolbars.buttons["Done"].tap()
        
        app.navigationBars["B2BTutoring.EditProfileView"].buttons["Done"].tap()
        app.alerts["Alert"].collectionViews.buttons["OK"].tap()
        
        XCTAssert(app.tables.staticTexts["Leo Luo"].exists)
        XCTAssert(app.tables.staticTexts["leoyue94@gmail.com"].exists)
        XCTAssert(app.tables.staticTexts["#play guitar"].exists)
        XCTAssert(app.tables.staticTexts["Music"].exists)
        XCTAssert(app.tables.staticTexts["I am a CS nerd."].exists)
    }
    
}


extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) -> Void {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        self.tap()
        var deleteString: String = ""
        for _ in stringValue.characters {
            deleteString += "\u{8}"
        }
        self.typeText(deleteString)
        self.typeText(text)
    }

    
}
