//
//  Forecast.swift
//  WeatherTest
//
//  Created by Sergey Kobzin on 30.01.2018.
//  Copyright © 2018 Sergey Kobzin. All rights reserved.
//

import UIKit

class Forecast {
    
    var date: String
    var weather: Weather
    
    init(date: String, weather: Weather) {
        self.date = date
        self.weather = weather
    }
    
}
