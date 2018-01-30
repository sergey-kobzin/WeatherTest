//
//  WeatherTableViewCell.swift
//  WeatherTest
//
//  Created by Sergey Kobzin on 29.01.2018.
//  Copyright © 2018 Sergey Kobzin. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var geoCoordsLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    func setup(forWeather weather: Weather, inCity city: City) {
        cityNameLabel.text = city.name + ", " + city.country
        geoCoordsLabel.text = "Geo coords: [" + city.latitude + ", " + city.longitude + "]"
        weatherImageView.image = UIImage(named: weather.icon)
        temperatureLabel.text = weather.temperature + " ℃"
        descriptionLabel.text = weather.description.capitalized
        pressureLabel.text = "Pressure: " + weather.pressure + " mmHg"
        humidityLabel.text = "Humidity: " + weather.humidity + " %"
    }
    
}
