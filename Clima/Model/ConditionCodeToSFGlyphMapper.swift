//
// Created by Thomas Strauß on 12.06.21.
// Copyright (c) 2021 App Brewery. All rights reserved.
//

import Foundation


struct ConditionCodeMapper {

    static func toSFGlyph(weatherId: Int) -> String {
        switch(weatherId) {
        case 200...299:
            return "cloud.bolt"
        case 300...399:
            return "cloud.drizzle"
        case 500...599:
            return "cloud.rain"
        case 600...699:
            return "cloud.snow"
        case 721:
            return "sun.haze"
        case 731,761:
            return "sun.dust"
        case 700...799:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...899:
            return "cloud.sun"
        default:
            return "cloud"
        }
    }

}