//
//  UalaUITests.swift
//  UalaUITests
//
//  Created by Carlos Mario Muñoz on 21/03/25.
//

import XCTest

final class UalaUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .portrait
    }

    override func tearDownWithError() throws {
    }

    @MainActor
    func test_cityList_usesMockedCities() throws {
        let app = XCUIApplication()
        app.launchArguments = ["UI-TESTING"]
        app.launchEnvironment["MOCK_CITY_COUNT"] = "500"
        app.launch()
        let cityList = app.collectionViews["cityList"]
        let exists = cityList.waitForExistence(timeout: 1)
        XCTAssertTrue(exists, "'cityList' CollectionView should appear after mock delay.")
        let firstCell = cityList.cells.element(boundBy: 0)
        XCTAssertTrue(firstCell.exists, "First cell should appear.")
    }
    
    @MainActor
    func test_cityList_usesEmptyMockedCities() throws {
        let app = XCUIApplication()
        app.launchArguments = ["UI-TESTING"]
        app.launchEnvironment["MOCK_CITY_COUNT"] = "0"
        app.launch()
        let emptyLabel = app.staticTexts["emptyMessage"]
        let exists = emptyLabel.waitForExistence(timeout: 1)
        XCTAssertTrue(exists, "Empty message should appear when there are no cities.")
    }
    
    @MainActor
    func test_cityList_getMap() throws {
        let app = XCUIApplication()
        app.launchArguments = ["UI-TESTING"]
        app.launchEnvironment["MOCK_CITY_COUNT"] = "1"
        app.launch()

        let cell = app.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 1))
        cell.tap()

        let map = app.otherElements["cityMap"]
        XCTAssertTrue(map.waitForExistence(timeout: 1), "Map should appear after tapping the cell.")
    }
    
    @MainActor
    func test_mapAppearsInLandscape() {
        let app = XCUIApplication()
        app.launchArguments = ["UI-TESTING"]
        app.launchEnvironment["MOCK_CITY_COUNT"] = "1"
        app.launch()

        XCUIDevice.shared.orientation = .landscapeLeft

        sleep(1)
        
        let cell = app.cells.element(boundBy: 0)
        XCTAssertTrue(cell.waitForExistence(timeout: 1))
        cell.tap()

        let map = app.otherElements["cityMap"]
        XCTAssertTrue(map.waitForExistence(timeout: 2), "Map should be visible in landscape.")
    }

    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
