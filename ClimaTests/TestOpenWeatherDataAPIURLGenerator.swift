//
//  TestOpenWeatherDataAPIURLGenerator.swift
//  Clima
//
//  Created by Thomas Strauß on 13.06.21.
//  Copyright © 2021 App Brewery. All rights reserved.
//

import XCTest
@testable import Clima

class TestOpenWeatherDataAPIURLGenerator: XCTestCase {

    func testIfTheURLIsCorrectWithCityName() {
        let generator = OpenWeatherDataAPIURLGenerator(apiKey: "bla&?!=bla")

        let url = generator.forCityName("shitty")
        let url2 = generator.forCityName("&?!=")

        XCTAssertEqual("https://api.openweathermap.org/data/2.5/weather?appid=bla%26%3F%21%3Dbla&units=metric&lang=de&q=shitty", url)
        XCTAssertEqual("https://api.openweathermap.org/data/2.5/weather?appid=bla%26%3F%21%3Dbla&units=metric&lang=de&q=%26%3F%21%3D", url2)
    }

    func testIfTheURLIsCorrectWithLocationData() {
        let generator = OpenWeatherDataAPIURLGenerator(apiKey: "bla&?!=bla")

        let url = generator.forLocation(lat: "here", lon: "there")
        let url2 = generator.forLocation(lat: "here&?!=", lon: "there&?!=")

        XCTAssertEqual("https://api.openweathermap.org/data/2.5/weather?appid=bla%26%3F%21%3Dbla&units=metric&lang=de&lat=here&lon=there", url)
        XCTAssertEqual("https://api.openweathermap.org/data/2.5/weather?appid=bla%26%3F%21%3Dbla&units=metric&lang=de&lat=here%26%3F%21%3D&lon=there%26%3F%21%3D", url2)
    }

}
