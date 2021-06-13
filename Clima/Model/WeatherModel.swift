//
// Created by Thomas Strauß on 13.06.21.
// Copyright (c) 2021 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {

    let conditionId : Int
    let cityName : String
    let temperature : Double
    var temperatureAsString : String {
        String(format: "%.1f", temperature)
    }
    var conditionName : String {
        ConditionCodeMapper.toSFGlyph(weatherId: conditionId)
    }
}
