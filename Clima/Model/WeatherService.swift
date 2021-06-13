//
// Created by Thomas Strauß on 12.06.21.
// Copyright (c) 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherService {

    let apiKey = "33486c1118da447b0a7ccffa2c68003e"
    let weatherURLtemplate = "https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}&units=metric"

    var urlSession: URLSession = URLSession.shared

    public var delegate: WeatherServiceDelegate?

    private func getWeatherURL(cityName: String) -> URL? {
        URL(string: weatherURLtemplate
                .replacingOccurrences(of: "{city name}", with: cityName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
                .replacingOccurrences(of: "{API key}", with: apiKey))
    }

    func obtainWeatherData(_ cityName: String) {
        if let weatherURL = getWeatherURL(cityName: cityName) {

            let task: URLSessionDataTask = urlSession.dataTask(with: weatherURL, completionHandler: handleWeatherResult)

            task.resume()
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
