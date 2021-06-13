//
// Created by Thomas Strauß on 12.06.21.
// Copyright (c) 2021 App Brewery. All rights reserved.
//

import Foundation

struct MainJsonData: Decodable {
    let temp : Double
}

struct WeatherItemJson: Decodable{
    let id: Int
    let description: String
}

struct WeatherJsonData: Decodable {
    let name : String
    let main : MainJsonData
    let weather : [WeatherItemJson]
}
