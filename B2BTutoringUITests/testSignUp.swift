//
//  testSignUp.swift
//  B2BTutoring
//
//  Created by 罗阅 on 11/19/15.
//  Copyright © 2015 Team 1. All rights reserved.
//

import XCTest

class testSignUp: XCTestCase {
        
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
    
    func testGoToSignUp(){
        let app = XCUIApplication()
        app.buttons["SIGN UP"].tap()
        XCTAssertNotNil(XCUIApplication().staticTexts["ENTER YOUR PHONE NUMBER"]) //successfully go to sign up page
        
    }
    
    func testTypeInPhoneNum(){
        let app = XCUIApplication()
        app.buttons["SIGN UP"].tap()
        app.buttons["\u{00d7}"].tap()   //if there are no digits, delete digit will have no effect
        
        //test tapping the digits
        app.buttons["1"].tap()
        app.buttons["2"].tap()
        app.buttons["3"].tap()
        app.buttons["4"].tap()
        app.buttons["5"].tap()
        app.buttons["6"].tap()
        app.buttons["7"].tap()
        app.buttons["8"].tap()
        app.buttons["9"].tap()
        app.buttons["0"].tap()
        
        XCTAssert(app.staticTexts["123 456 7890"].exists)
        
        app.buttons["1"].tap()
        XCTAssert(app.staticTexts["123 456 7890"].exists) //after typing in 10 digits, typing additional digits will have no effect
        
        //test deleting the digits
        app.buttons["\u{00d7}"].tap()
        app.buttons["\u{00d7}"].tap()
        app.buttons["\u{00d7}"].tap()
        app.buttons["\u{00d7}"].tap()
        app.buttons["\u{00d7}"].tap()
        app.buttons["\u{00d7}"].tap()
        app.buttons["\u{00d7}"].tap()
        app.buttons["\u{00d7}"].tap()
        app.buttons["\u{00d7}"].tap()
        
        XCTAssert(app.staticTexts["1"].exists)
        
    }
    
    func testContinueSignUp(){
        
        let app = XCUIApplication()
        app.buttons["SIGN UP"].tap()
        
        //test pressing advance without phone number
        let advanceButton = app.buttons["\u{203a}"]
        advanceButton.tap()
        XCTAssert(app.staticTexts["*PLEASE ENTER A VALID PHONE NUMBER*"].exists)
        
        //test pressing advance without valid phone number(less than 10 digits)
        app.buttons["0"].tap()
        app.buttons["0"].tap()
        app.buttons["0"].tap()
        advanceButton.tap()
        XCTAssert(app.staticTexts["*PLEASE ENTER A VALID PHONE NUMBER*"].exists)
        
        //test advance to verification code input
        app.buttons["1"].tap()
        app.buttons["2"].tap()
        app.buttons["3"].tap()
        app.buttons["4"].tap()
        app.buttons["5"].tap()
        app.buttons["6"].tap()
        app.buttons["7"].tap()
        app.buttons["8"].tap()
        app.buttons["9"].tap()
        app.buttons["0"].tap()
        advanceButton.tap()
        XCTAssert(app.staticTexts["ENTER THE VERIFICATION CODE WE JUST SENT YOU"].exists)
        
        //test advance without verification code
        advanceButton.tap()
        XCTAssert(app.staticTexts["*PLEASE ENTER THE CORRECT CODE*"].exists)
        
        //test advance with invalid verification code: either incorrect or invalid(length less than 4)
        app.buttons["0"].tap()
        app.buttons["0"].tap()
        advanceButton.tap()
        XCTAssert(app.staticTexts["*PLEASE ENTER THE CORRECT CODE*"].exists)
        
        //in UI test there is no way to fetch the verification code, so I do not test with the successful sign up
        
    }
    
}
