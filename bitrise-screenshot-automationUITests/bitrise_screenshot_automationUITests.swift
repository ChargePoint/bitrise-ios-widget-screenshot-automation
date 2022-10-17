//
//  bitrise_screenshot_automationUITests.swift
//  bitrise-screenshot-automationUITests
//
//  Created by Alexander Botkin on 4/20/20.
//  Copyright © 2020 ChargePoint, Inc. All rights reserved.
//

import XCTest

enum SwipeDirection {
    case Up
    case Down
    case Left
    case Right
}

extension XCTestCase {
    func handleAlerts(app: XCUIApplication) {
        app.tap()
        self.addUIInterruptionMonitor(withDescription: "Handling system alerts") { element in
            if (element.buttons.count > 2) {
                // this is the case for location where there are 3 cases so we will pick the second option which is
                // use location while in app
                let whileInUseButton = element.buttons.secondLastMatch
                if (whileInUseButton.exists) {
                    whileInUseButton.tap()
                    app.tap()
                    return true
                }
            }
            
            return false
        }
    }
}

extension XCUIApplication {
    func swipe(direction: SwipeDirection, numSwipes: Int) {
        switch direction {
        case .Up:
            for _ in 1...numSwipes {
                self.swipeUp()
            }
        case .Down:
            for _ in 1...numSwipes {
                self.swipeDown()
            }
        case .Left:
            for _ in 1...numSwipes {
                self.swipeLeft()
            }
        case .Right:
            for _ in 1...numSwipes {
                self.swipeRight()
            }
        }
    }
}

extension XCUIElementQuery {
    var secondMatch: XCUIElement {return self.element(boundBy: 1)}
    var lastMatch: XCUIElement { return self.element(boundBy: self.count - 1) }
    var secondLastMatch: XCUIElement { return self.element(boundBy: self.count - 2) }
    var thirdLastMatch: XCUIElement { return self.element(boundBy: self.count - 3) }
}

class bitrise_screenshot_automationUITests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        self.handleAlerts(app: app)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testMainViewScreenshot() throws {
        let app = XCUIApplication()
        
        // Let's ensure the view has appeared by using the accessibility identifier
        // we set up in the storyboard
        let darkMapVCView = app.otherElements["Dark Map View"];
        XCTAssertTrue(darkMapVCView.waitForExistence(timeout: 3))

        // Now let's get a screenshot & save it to the xcresult as an attachment
        self.saveScreenshot("MyAutomation_darkMapView")
    }

    func testTodayWidgetScreenshot() throws {
        let app = XCUIApplication()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboard.activate()

        springboard.swipe(direction: .Right, numSwipes: 2)
        springboard.swipe(direction: .Up, numSwipes: 2)

        let editButton = springboard.buttons.firstMatch
        XCTAssertTrue(editButton.waitForExistence(timeout: 3))
        editButton.tap()

        springboard.swipe(direction: .Up, numSwipes: 3)
        
        var customizeButton = springboard.buttons.secondLastMatch
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            if #available(iOS 16, *) {
                customizeButton = springboard.buttons.lastMatch
            }
            break
        case .pad:
            customizeButton = springboard.buttons.lastMatch
            break
        default:
            break
        }
    
        customizeButton.tap()
        
        let widgetNamePredicate = NSPredicate(format: "label CONTAINS[c] 'TodayWidget'")
        let addWidgetCells = springboard.cells.matching(widgetNamePredicate)
        addWidgetCells.buttons.firstMatch.tap()

        let doneButton = springboard.navigationBars.buttons.secondMatch
        doneButton.tap()

        springboard.swipe(direction: .Up, numSwipes: 1)
        let todayLabel = springboard.staticTexts["Today Label"]
        XCTAssertTrue(todayLabel.waitForExistence(timeout: 3))
        
        self.saveScreenshot("MyAutomation_todayWidget")
        
        // Remove today widget
        customizeButton = springboard.buttons.secondLastMatch
        customizeButton.tap()
        
        addWidgetCells.buttons.firstMatch.tap()
        addWidgetCells.buttons.lastMatch.tap()
        
        doneButton.tap()
        
        app.activate()
    }
    
    func testLockScreenWidgetScreenshot() throws {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboard.activate()
        
        let coord1 = springboard.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let coord2 = springboard.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 2))
        coord1.press(forDuration: 0.1, thenDragTo: coord2)
        
        addLockScreenWidget()
        
        self.saveScreenshot("MyAutomation_lockScreenWidget")
        
        editLockScreenWidget()
        
        self.saveScreenshot("MyAutomation_configuredLockScreenWidget")
        
        removeLockScreenWidget()
    }
    
    func addLockScreenWidget() {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboard.press(forDuration: 3)
    
        springboard.buttons.matching(identifier: "posterboard-customize-button").firstMatch.tap()
        
        springboard.collectionViews["posterboard-collection-view"].cells.firstMatch.tap()
        
        let posterboard = XCUIApplication(bundleIdentifier: "com.apple.PosterBoard")
        
        posterboard.buttons.lastMatch.tap()
        
        posterboard.cells["bitrise-screenshot-automation"].tap()
        
        springboard.buttons.lastMatch.tap()
        
        springboard.buttons.firstMatch.tap()
        
        springboard.buttons.firstMatch.tap()
        
        springboard.buttons.secondMatch.tap()
        
        springboard.tap()
    }
    
    func editLockScreenWidget() {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboard.press(forDuration: 3)
    
        springboard.buttons.matching(identifier: "posterboard-customize-button").firstMatch.tap()
        
        springboard.collectionViews["posterboard-collection-view"].cells.firstMatch.tap()
        
        let posterboard = XCUIApplication(bundleIdentifier: "com.apple.PosterBoard")
        
        posterboard.buttons.firstMatch.tap()
        posterboard.buttons.secondMatch.tap()
        
        self.saveScreenshot("MyAutomation_lockScreenWidgetConfiguration")
        
        springboard.buttons.secondMatch.tap()
        springboard.searchFields.firstMatch.tap()
        springboard.typeText("San Jose\n")
        springboard.cells.firstMatch.tap()
        springboard.buttons.secondMatch.tap()
        springboard.buttons.firstMatch.tap()
        
        springboard.buttons.firstMatch.tap()
        springboard.buttons.secondMatch.tap()
        springboard.tap()
    }
    
    func removeLockScreenWidget() {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboard.press(forDuration: 3)
    
        springboard.buttons.matching(identifier: "posterboard-customize-button").firstMatch.tap()
        
        springboard.collectionViews["posterboard-collection-view"].cells.firstMatch.tap()
        
        let posterboard = XCUIApplication(bundleIdentifier: "com.apple.PosterBoard")
        
        posterboard.buttons.firstMatch.tap()
        
        posterboard.buttons.firstMatch.tap()
        
        posterboard.buttons.firstMatch.tap()
        
        posterboard.buttons.secondMatch.tap()
        
        springboard.tap()
    }
    
    func testHomeScreenWidgetScreenshot() throws {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboard.activate()
        
        addHomeScreenWidget(isMediumSize: false)
        addHomeScreenWidget(isMediumSize: true)
        
        self.saveScreenshot("MyAutomation_homeScreenWidgets")
        
        editHomeScreenWidgetConfig()
        
        sleep(1)
        
        self.saveScreenshot("MyAutomation_configuredHomeScreenWidget")
                
        removeHomeScreenWidget()
        removeHomeScreenWidget()
    }
    
    func editHomeScreenWidgetConfig() {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboard.press(forDuration: 3)
        springboard.icons.matching(identifier: "bitrise-screenshot-automation").firstMatch.tap()
        
        let widgetConfig = XCUIApplication(bundleIdentifier: "com.apple.WorkflowUI.WidgetConfigurationExtension")
        
        sleep(1)
        
        self.saveScreenshot("MyAutomation_homeScreenWidgetConfiguration")
        
        widgetConfig.buttons.firstMatch.tap()
        widgetConfig.searchFields.firstMatch.tap()
        widgetConfig.typeText("San Jose\n")
        widgetConfig.cells.firstMatch.tap()
        widgetConfig.buttons.secondMatch.tap()
        
        springboard.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0)).tap()
        
        springboard.buttons.secondMatch.tap()
    }
    
    func removeHomeScreenWidget() {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboard.press(forDuration: 3)
        
        springboard.icons.matching(identifier: "bitrise-screenshot-automation").firstMatch.buttons["DeleteButton"].tap()
        springboard.alerts.firstMatch.buttons.lastMatch.tap()
        springboard.buttons.secondMatch.tap()
    }
    
    func addHomeScreenWidget(isMediumSize: Bool) {
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        springboard.press(forDuration: 3)
        
        springboard.buttons.firstMatch.tap()

        springboard.searchFields.firstMatch.tap()
        
        springboard.typeText("bitrise-screenshot-automation")
        springboard.collectionViews.cells["bitrise-screenshot-automation"].tap()
        
        if (isMediumSize) {
            springboard.swipe(direction: .Left, numSwipes: 1)
        }
        
        springboard.buttons.thirdLastMatch.tap()
        
        springboard.buttons.secondMatch.tap()
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
