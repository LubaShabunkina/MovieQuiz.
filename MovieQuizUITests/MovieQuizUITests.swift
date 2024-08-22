//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Luba Shabunkina on 14/08/2024.
//


import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app.terminate()
        app = nil
    }
    
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testYesButton() {
        sleep(3)
        
        let firstPoster = app.images ["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        
        app.buttons["Yes"].tap()
        sleep(3)
        
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        
        //XCTAssertTrue(firstPoster.exists)
        XCTAssertFalse(firstPoster == secondPoster)
        //XCTAssertTrue(secondPoster.exists)
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testNoButton() {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "3/10")
    }
    
    
    func testGameFinish() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            let _ = app.buttons["No"].waitForExistence(timeout: 2) // Ожидание появления кнопки
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5))
        
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons["Сыграть ещё раз"].exists)
    }
    
    
    
    func testAlertDismiss() {
        for _ in 1...10 {
            app.buttons["No"].tap()
            let _ = app.buttons["No"].waitForExistence(timeout: 10)
        }
        
        // Проверяем, что индекс отображается правильно перед проверкой алерта
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "10/10", "Index label text is incorrect before alert.")
        
        // Ожидаем появления алерта
        let alert = app.alerts["Этот раунд окончен!"]
        let alertExists = alert.waitForExistence(timeout: 10)
        XCTAssertTrue(alertExists, "Alert did not appear.")
        
        // Проверяем существование кнопки "Сыграть ещё раз" и нажимаем её
        let button = alert.buttons["Сыграть ещё раз"]
        XCTAssertTrue(button.exists, "Play again button does not exist.")
        button.tap()
        
        // Добавляем небольшую задержку, чтобы UI успел обновиться
        sleep(2)
        
        // Ожидаем, что алерт исчезает
        let alertDisappeared = !alert.waitForExistence(timeout: 2)
        XCTAssertTrue(alertDisappeared, "Alert did not disappear.")
        
        // Ожидаем обновления индекса
        let updatedIndexLabel = app.staticTexts["Index"]
        XCTAssertTrue(updatedIndexLabel.waitForExistence(timeout: 10), "Index label did not appear.")
        XCTAssertEqual(updatedIndexLabel.label, "1/10", "Index label text is incorrect after alert dismissal.")
    }
}
