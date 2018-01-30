//
//  City.swift
//  WeatherTest
//
//  Created by Sergey Kobzin on 26.01.2018.
//  Copyright © 2018 Sergey Kobzin. All rights reserved.
//

import UIKit

class City {
    
    var name: String
    var country: String
    var latitude: String
    var longitude: String
    
    init(name: String, country: String, latitude: Float, longitude: Float) {
        self.name = name
        self.country = country
        self.latitude = latitude.description
        self.longitude = longitude.description
    }
    
}

func ==(lhs: City, rhs: City) -> Bool {
    let isEqual = lhs.name.lowercased() == rhs.name.lowercased() && lhs.country.lowercased() == rhs.country.lowercased() && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    return isEqual
}

func !=(lhs: City, rhs: City) -> Bool {
    let isEqual = lhs == rhs
    return !isEqual
}

