//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController,UITextFieldDelegate,WeatherServiceDelegate {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!

    var weatherService : WeatherService = WeatherService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchTextField.delegate = self
        weatherService.delegate = self
    }

    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }

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
            weatherService.obtainWeatherData(cityName)
        }
    }

    func didUpdateWeatherData(_ weatherService:WeatherService, weatherData: WeatherModel) {
        print("received data \(weatherData)")
        DispatchQueue.main.async {
            self.temperatureLabel.text = weatherData.temperatureAsString
            self.cityLabel.text = weatherData.cityName
            self.conditionImageView.image = UIImage(systemName: weatherData.conditionName)
        }
    }

    func didReceiveErrorOnWeatherData(_ weatherService:WeatherService, error: Error) {
        print("weather is a failure: \(error)")
        DispatchQueue.main.async {
        }
    }

}

