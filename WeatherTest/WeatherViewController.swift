//
//  WeatherViewController.swift
//  WeatherTest
//
//  Created by Sergey Kobzin on 26.01.2018.
//  Copyright © 2018 Sergey Kobzin. All rights reserved.
//

import UIKit

class WeatherViewController: UITableViewController {
    
    var city: City?
    var weather: Weather?
    var forecasts: [Forecast]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let city = city else { return }
        let name = city.name
        let country = city.country
        NetworkManager.getWeatherForCity(withName: name, inCountry: country, completionHandler: { (weather, error) in
            guard error == nil, let weather = weather else { return }
            self.weather = weather
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        NetworkManager.getForecastsForCity(withName: name, inCountry: country, completionHandler: { (forecasts, error) in
            guard error == nil, let forecasts = forecasts else { return }
            self.forecasts = forecasts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        if weather != nil {
            count += 1
        }
        if let forecasts = forecasts {
            count += forecasts.count
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        if index == 0 {
            guard let weather = weather, let city = city, let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as? WeatherTableViewCell else { return UITableViewCell() }
            cell.setup(forWeather: weather, inCity: city)
            return cell
        }
        guard let forecasts = forecasts, let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? ForecastTableViewCell else { return UITableViewCell() }
        let forecast = forecasts[index - 1]
        cell.backgroundColor = index % 2 == 0 ? .white : Colors.cellColor
        cell.setup(forForecast: forecast)
        return cell
    }
    
}
