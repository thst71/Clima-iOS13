//
// Created by Thomas Strauß on 13.06.21.
// Copyright (c) 2021 App Brewery. All rights reserved.
//

import UIKit

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        }

        textField.placeholder = "Type some city name"
        return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Obtaining weather for \(searchTextField.text)")
        if let cityName = searchTextField.text {
            weatherService.obtainWeatherData(cityName: cityName)
        }
    }
}
