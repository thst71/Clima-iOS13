//
// Created by Thomas Strauß on 13.06.21.
// Copyright (c) 2021 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

extension WeatherViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            manager.stopUpdatingLocation()
            let lat = "\(lastLocation.coordinate.latitude)"
            let lon = "\(lastLocation.coordinate.longitude)"

            print(lat, "/", lon)
            weatherService.obtainWeatherData(lat: lat, lon: lon)
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("outch in corelocation \(error)")
    }
}