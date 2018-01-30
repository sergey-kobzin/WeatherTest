//
//  ForecastTableViewCell.swift
//  WeatherTest
//
//  Created by Sergey Kobzin on 30.01.2018.
//  Copyright © 2018 Sergey Kobzin. All rights reserved.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    
    func setup(forForecast forecast: Forecast) {
        dateLabel.text = forecast.date
        weatherImageView.image = UIImage(named: forecast.weather.icon)
        temperatureLabel.text = forecast.weather.temperature + " ℃"
        descriptionLabel.text = forecast.weather.description.capitalized
        pressureLabel.text = "Pressure: " + forecast.weather.pressure + " mmHg"
        humidityLabel.text = "Humidity: " + forecast.weather.humidity + " %"
    }
    
}
