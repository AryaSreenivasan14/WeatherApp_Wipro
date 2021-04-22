//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by Arya Sreenivasan on 09/04/21.
//

import XCTest

class WeatherAppUITests: XCTestCase {

    override func setUpWithError() throws {
        //continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testApplicationUI() throws {
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        sleep(1)
        
        if (app.tables.element(boundBy: 0).cells.count > 0) {
            app.tables.element(boundBy: 0).cells.element(boundBy: 0).tap()
            sleep(1)
            //app.buttons["backButton"].tap(wait: 20, test: self)
            
            if (app.navigationBars.buttons.count > 0) {
                app.navigationBars.buttons.element(boundBy: 0).tap()
            }
        }
                        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCUIElement {
    func tap(wait: Int, test: XCTestCase) {
        if !isHittable {
            test.expectation(for: NSPredicate(format: "exists == true"), evaluatedWith: self, handler: nil)
            test.waitForExpectations(timeout: TimeInterval(wait), handler: nil)
        }
        tap()
    }
}
