//
//  USWeatherAppTests.swift
//  USWeatherAppTests
//
//  Created by Rev on 09/04/23.
//

import XCTest
@testable import USWeatherApp

class USWeatherAppTests: XCTestCase {
    
    var sut: WeatherViewModel!
    var session: URLSession!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = WeatherViewModel()
        session = URLSession(configuration: .default)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        session = nil
        try super.tearDownWithError()
    }
    
    func testCityName() throws {
        // given
        sut.cityName = "New York"
        sut.fetchWeather(by: sut.cityName)
        XCTAssertTrue(sut.cityName.count > 0, "City name is not empty")
        XCTAssertEqual(sut.cityName, "New York", "Both are equal")
    }
    
    func testApiCallCompletes() throws {
        // given
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=40.759211&lon=-73.984638&appid=22628551c6ceddb0e3815b0ec6ea2be5"
        let url = URL(string: urlString)!
        let promise = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        // when
        let dataTask = session.dataTask(with: url) { _, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            promise.fulfill()
        }
        dataTask.resume()
        wait(for: [promise], timeout: 5)
        
        // then
        let sCode = try XCTUnwrap(statusCode)

        XCTAssertNil(responseError)
        XCTAssertEqual(sCode, 200)
    }
}
