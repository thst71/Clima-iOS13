//
// Created by Thomas Strauß on 12.06.21.
// Copyright (c) 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherService {

    enum WeatherServiceError: Error {
        case InvalidWeatherAPIURL
    }

    let apiURLs: OpenWeatherDataAPIURLGenerator? = OpenWeatherDataAPIURLGenerator(apiKey: "33486c1118da447b0a7ccffa2c68003e")
    var urlSession: URLSession = URLSession.shared

    public var delegate: WeatherServiceDelegate?

    func obtainWeatherData(cityName: String) {
        let weatherURLString = apiURLs!.forCityName(cityName)
        fetchWeatherData(weatherURLString)
    }

    func obtainWeatherData(lat: String, lon: String) {
        let weatherURLString = apiURLs!.forLocation(lat: lat, lon: lon)
        fetchWeatherData(weatherURLString)
    }

    private func fetchWeatherData(_ apiUrlString: String) {
        if let apiUrl = URL(string: apiUrlString) {
            let task: URLSessionDataTask = urlSession.dataTask(with: apiUrl, completionHandler: handleWeatherResult)

            task.resume()
        } else {
            delegate?.didReceiveErrorOnWeatherData(self, error: WeatherServiceError.InvalidWeatherAPIURL)
        }
    }

    private func handleWeatherResult(dataBlock: Data?, response: URLResponse?, error: Error?) {
        print("""
              response:\(String(describing: response))
              error:\(String(describing: error))
              """)

        if let realError = error {
            delegate?.didReceiveErrorOnWeatherData(self, error: realError)
            return
        }

        print("data received \(String(data: dataBlock!, encoding: .utf8)!)")

        if let weatherJson = decodeWeatherDataFromJson(dataBlock!) {
            let weather = WeatherModel(conditionId: weatherJson.weather[0].id,
                    cityName: weatherJson.name,
                    temperature: weatherJson.main.temp)

            delegate?.didUpdateWeatherData(self, weatherData: weather)
        }
    }

    private func decodeWeatherDataFromJson(_ jsonData: Data) -> WeatherJsonData? {
        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode(WeatherJsonData.self, from: jsonData)
            print("\(decodedData.name) : \(decodedData.main.temp) - \(decodedData.weather[0].description)")
            return decodedData
        } catch {
            print(error)
            delegate?.didReceiveErrorOnWeatherData(self, error: error)
            return nil
        }
    }
}
