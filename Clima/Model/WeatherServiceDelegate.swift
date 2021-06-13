//
// Created by Thomas Strauß on 12.06.21.
// Copyright (c) 2021 App Brewery. All rights reserved.
//

import Foundation

protocol WeatherServiceDelegate {

    func didUpdateWeatherData(_ weatherService: WeatherService, weatherData:WeatherModel)
    func didReceiveErrorOnWeatherData(_ weatherService: WeatherService, error:Error)

}
