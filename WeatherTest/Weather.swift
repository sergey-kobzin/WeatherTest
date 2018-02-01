//
//  Weather.swift
//  WeatherTest
//
//  Created by Sergey Kobzin on 28.01.2018.
//  Copyright © 2018 Sergey Kobzin. All rights reserved.
//

import UIKit

class Weather {
    
    var temperature: String
    var pressure: String
    var humidity: String
    var description: String
    var icon: String
    var windDirection: String
    var windSpeed: String
    
    init(temperature: Float?, pressure: Float?, humidity: Int?, description: String?, icon: String?, windDirection: Float?, windSpeed: Float?) {
        if let temperature = temperature {
            self.temperature = String(format: "%.1f", (temperature - 273.15)) // Convert from Kelvin to Celsius
        } else {
            self.temperature = "Unknown"
        }
        if let pressure = pressure {
            self.pressure = String(format: "%.0f", (pressure * 0.750063755))  // Convert from hPA to mmHg
        } else {
            self.pressure = "Unknown"
        }
        self.humidity = humidity?.description ?? "Unknown"
        self.description = description ?? "Unknown"
        self.icon = icon ?? "Unknown"
        if let windDirection = windDirection {
            switch windDirection {                                            // Convert from degrees to Wind Rose
            case 0.0 ..< 11.25:
                self.windDirection = "N"
            case 11.25 ..< 33.75:
                self.windDirection = "NNE"
            case 33.75 ..< 56.25:
                self.windDirection = "NE"
            case 56.25 ..< 78.75:
                self.windDirection = "ENE"
            case 78.75 ..< 101.25:
                self.windDirection = "E"
            case 101.25 ..< 123.75:
                self.windDirection = "ESE"
            case 123.75 ..< 146.25:
                self.windDirection = "SE"
            case 146.25 ..< 168.75:
                self.windDirection = "SSE"
            case 168.75 ..< 191.25:
                self.windDirection = "S"
            case 191.25 ..< 213.75:
                self.windDirection = "SSW"
            case 213.75 ..< 236.25:
                self.windDirection = "SW"
            case 236.25 ..< 258.75:
                self.windDirection = "WSW"
            case 258.75 ..< 281.25:
                self.windDirection = "W"
            case 281.25 ..< 303.75:
                self.windDirection = "WNW"
            case 303.75 ..< 326.25:
                self.windDirection = "NW"
            case 326.25 ..< 348.75:
                self.windDirection = "NNW"
            case 348.75 ..< 360.0:
                self.windDirection = "N"
            default:
                self.windDirection = "Unknown"
                break
            }
        } else {
            self.windDirection = "Unknown"
        }
        if let windSpeed = windSpeed {
            self.windSpeed = String(format: "%.1f", windSpeed)
        } else {
            self.windSpeed = "Unknown"
        }
    }
    
    init(temperature: String?, pressure: String?, humidity: String?, description: String?, icon: String?, windDirection: String?, windSpeed: String?) {
        self.temperature = temperature ?? "Unknown"
        self.pressure = pressure ?? "Unknown"
        self.humidity = humidity ?? "Unknown"
        self.description = description ?? "Unknown"
        self.icon = icon ?? "Unknown"
        self.windDirection = windDirection ?? "Unknown"
        self.windSpeed = windSpeed ?? "Unknown"
    }
    
}
