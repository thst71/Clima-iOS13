//
// Created by Thomas Strauß on 13.06.21.
// Copyright (c) 2021 App Brewery. All rights reserved.
//

import UIKit

extension WeatherViewController: WeatherServiceDelegate {
    func didUpdateWeatherData(_ weatherService: WeatherService, weatherData: WeatherModel) {
        print("received data \(weatherData)")
        DispatchQueue.main.async {
            self.temperatureLabel.text = weatherData.temperatureAsString
            self.cityLabel.text = weatherData.cityName
            self.conditionImageView.image = UIImage(systemName: weatherData.conditionName)
        }
    }

    func didReceiveErrorOnWeatherData(_ weatherService: WeatherService, error: Error?) {
        print("weather is a failure: \(error)")
        DispatchQueue.main.async {
        }
    }
}
