//
// Created by Thomas Strauß on 13.06.21.
// Copyright (c) 2021 App Brewery. All rights reserved.
//

import Foundation

struct OpenWeatherDataAPIURLGenerator {
    let apiKey: String

    var weatherURLtemplate: String {
        var lang: String = "en"

        if let preferredIdentifier = Locale.preferredLanguages.first {
            lang = Locale(identifier: preferredIdentifier).languageCode ?? lang
        } else {
            lang = Locale.current.languageCode ?? lang
        }

        return "https://api.openweathermap.org/data/2.5/weather?appid=\(apiKey.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)&units=metric&lang=\(lang)"
    }

    func forLocation(lat: String, lon: String) -> String {
        let safeLat = lat.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        let safeLon = lon.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        return "\(weatherURLtemplate)&lat=\(safeLat)&lon=\(safeLon)"
    }

    func forCityName(_ cityName: String) -> String {
        let safeCity = cityName.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        return "\(weatherURLtemplate)&q=\(safeCity)"
    }
}
