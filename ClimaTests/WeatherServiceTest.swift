//
// Created by Thomas Strauß on 12.06.21.
// Copyright (c) 2021 App Brewery. All rights reserved.
//

import XCTest

@testable import Clima

class WeatherServiceTest : XCTestCase {

    class URLSessionDataTaskMock: URLSessionDataTask {
        private let closure: () -> Void

        init(closure: @escaping () -> Void) {
            self.closure = closure
        }

        // We override the 'resume' method and simply call our closure
        // instead of actually resuming any task.
        override func resume() {
            closure()
        }
    }

    class URLSessionMock : URLSession {
        typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

        // Properties that enable us to set exactly what data or error
        // we want our mocked URLSession to return for any request.
        var data: Data?
        var error: Error?

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) -> URLSessionDataTask {
            let data = self.data
            let error = self.error

            return URLSessionDataTaskMock {
                completionHandler(data, nil, error)
            }
        }
    }

    private struct TheServiceShouldDecodeJsonAndCallTheDelegateResult {
        var weatherData : WeatherModel?
        var weatherError : Error?
    }

    private class WeatherServiceTestDelegate : WeatherServiceDelegate {
        typealias TestResultAsserter = (TheServiceShouldDecodeJsonAndCallTheDelegateResult) -> Void
        var testResult : TheServiceShouldDecodeJsonAndCallTheDelegateResult
        var assertResult : TestResultAsserter?

        convenience init() {
            self.init(TheServiceShouldDecodeJsonAndCallTheDelegateResult())
        }

        init(_ testResult:TheServiceShouldDecodeJsonAndCallTheDelegateResult, assertResult : TestResultAsserter? = nil) {
            self.testResult = testResult
            self.assertResult = assertResult
        }

        func didUpdateWeatherData(_ weatherService:WeatherService, weatherData: WeatherModel) {
            testResult.weatherData = weatherData
            assertResult?(testResult)
        }

        func didReceiveErrorOnWeatherData(_ weatherService:WeatherService, error: Error) {
            testResult.weatherError = error
        }
    }

    func testTheServiceShouldDecodeJsonAndCallTheDelegate() {
        let testResult = TheServiceShouldDecodeJsonAndCallTheDelegateResult()
        let testDelegate = WeatherServiceTestDelegate(testResult) { (testResult) in
            XCTAssertTrue(testResult.weatherError == nil)
            XCTAssertTrue(testResult.weatherData != nil)
            XCTAssertEqual(testResult.weatherData?.name, "Cologne")
            XCTAssertEqual(testResult.weatherData?.weather.count, 1)
            XCTAssertEqual(testResult.weatherData?.weather[0].id, 800)
            XCTAssertEqual(testResult.weatherData?.main.temp, 21.9)
        }

        let mockedSession = URLSessionMock()
        mockedSession.data = "{\"coord\":{\"lon\":6.95,\"lat\":50.9333},\"weather\":[{\"id\":800,\"main\":\"Clear\",\"description\":\"clear sky\",\"icon\":\"01d\"}],\"base\":\"stations\",\"main\":{\"temp\":21.9,\"feels_like\":21.4,\"temp_min\":20.66,\"temp_max\":22.87,\"pressure\":1021,\"humidity\":48},\"visibility\":10000,\"wind\":{\"speed\":7.2,\"deg\":320},\"clouds\":{\"all\":0},\"dt\":1623518229,\"sys\":{\"type\":2,\"id\":2005976,\"country\":\"DE\",\"sunrise\":1623467887,\"sunset\":1623527172},\"timezone\":7200,\"id\":2886242,\"name\":\"Cologne\",\"cod\":200}\n"
                .data(using: .utf8)
        let weatherService: WeatherService = WeatherService(urlSession: mockedSession, delegate: testDelegate)

        weatherService.obtainWeatherData(cityName: "some city")

                
    }

}