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
        getWeather()
        getForecasts()
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
    
    // MARK: - Custom functions
    
    func getWeather() {
        guard let city = city else { return }
        DatabaseManager.getWeather(forCity: city, completionHandler: { (weather) in
            guard let weather = weather else { return }
            self.weather = weather
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        let name = city.name
        let country = city.country
        NetworkManager.getWeatherForCity(withName: name, inCountry: country, completionHandler: { (weather, error) in
            guard error == nil, let weather = weather else {
                AlertManager.showAlert(withTitle: "Error", withMessage: "Error getting weather from the server. You see the last saved data", inViewController: self)
                return
            }
            DatabaseManager.addWeather(weather: weather, forCity: city, completionHandler: { (success) in
                if !success {
                    AlertManager.showAlert(withTitle: "Error", withMessage: "Error saving data to the database", inViewController: self)
                }
            })
            self.weather = weather
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func getForecasts() {
        guard let city = city else { return }
        DatabaseManager.getForecasts(forCity: city, completionHandler: { (forecasts) in
            guard let forecasts = forecasts else { return }
            self.forecasts = forecasts.sorted(by: { $0.date < $1.date })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        let name = city.name
        let country = city.country
        NetworkManager.getForecastsForCity(withName: name, inCountry: country, completionHandler: { (forecasts, error) in
            guard error == nil, let forecasts = forecasts else {
                AlertManager.showAlert(withTitle: "Error", withMessage: "Error getting forecast from the server. You see the last saved data", inViewController: self)
                return
            }
            DatabaseManager.addForecasts(forecasts: forecasts, forCity: city, completionHandler: { (success) in
                if !success {
                    AlertManager.showAlert(withTitle: "Error", withMessage: "Error saving data to the database", inViewController: self)
                }
            })
            self.forecasts = forecasts.sorted(by: { $0.date < $1.date })
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
}
