//
//  NetworkManager.swift
//  WeatherTest
//
//  Created by Sergey Kobzin on 26.01.2018.
//  Copyright © 2018 Sergey Kobzin. All rights reserved.
//

import UIKit

class NetworkManager {
    
    static func getCities(withName name: String, completionHandler: @escaping (_ cities: [City]?, _ error: String?) -> ()) {
        let name = name.lowercased().replacingOccurrences(of: " ", with: "+")
        let urlString = APIRoutes.baseURL + APIRoutes.findCity + "?q=" + name + "&APPID=" + APIKeys.openWeatherMap
        guard let url = URL(string: urlString) else {
            completionHandler(nil, "URL is not correct")
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                completionHandler(nil, error.localizedDescription)
                return
            }
            guard let data = data else {
                completionHandler(nil, "Invalid response data")
                return
            }
            do {
                guard let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any], let listArray = jsonDictionary["list"] as? [[String : Any]] else {
                    completionHandler(nil, "Response parse error")
                    return
                }
                var cities = [City]()
                for listDictionary in listArray {
                    guard let name = listDictionary["name"] as? String, let coordDictionary = listDictionary["coord"] as? [String : Any], let sysDictionary = listDictionary["sys"] as? [String : Any], let lat = coordDictionary["lat"] as? Float, let lon = coordDictionary["lon"] as? Float, let country = sysDictionary["country"] as? String else {
                        completionHandler(nil, "Response parse error")
                        continue
                    }
                    let city = City(name: name, country: country, latitude: lat, longitude: lon)
                    cities.append(city)
                }
                completionHandler(cities, nil)
            } catch let error {
                completionHandler(nil, error.localizedDescription)
                return
            }
        }).resume()
    }
    
    static func getWeatherForCity(withName name: String, inCountry country: String, completionHandler: @escaping (_ weather: Weather?, _ error: String?) -> ()) {
        let name = name.lowercased().replacingOccurrences(of: " ", with: "+")
        let country = country.lowercased()
        let urlString = APIRoutes.baseURL + APIRoutes.getWeather + "?q=" + name + "," + country + "&APPID=" + APIKeys.openWeatherMap
        guard let url = URL(string: urlString) else {
            completionHandler(nil, "URL is not correct")
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                completionHandler(nil, error.localizedDescription)
                return
            }
            guard let data = data else {
                completionHandler(nil, "Invalid response data")
                return
            }
            do {
                guard let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any], let mainDictionary = jsonDictionary["main"] as? [String : Any], let weatherArray = jsonDictionary["weather"] as? [[String : Any]], let weatherDictionary = weatherArray.first, let windDictionary = jsonDictionary["wind"] as? [String : Any] else {
                    completionHandler(nil, "Response parse error")
                    return
                }
                let humidity = mainDictionary["humidity"] as? Int
                let pressure = mainDictionary["pressure"] as? Float
                let temp = mainDictionary["temp"] as? Float
                let description = weatherDictionary["description"] as? String
                let icon = weatherDictionary["icon"] as? String
                let deg = windDictionary["deg"] as? Float
                let speed = windDictionary["speed"] as? Float
                let weather = Weather(temperature: temp, pressure: pressure, humidity: humidity, description: description, icon: icon, windDirection: deg, windSpeed: speed)
                completionHandler(weather, nil)
            } catch let error {
                completionHandler(nil, error.localizedDescription)
                return
            }
        }).resume()
    }
    
    static func getForecastsForCity(withName name: String, inCountry country: String, completionHandler: @escaping (_ weather: [Forecast]?, _ error: String?) -> ()) {
        let name = name.lowercased().replacingOccurrences(of: " ", with: "+")
        let country = country.lowercased()
        let urlString = APIRoutes.baseURL + APIRoutes.getForecast + "?q=" + name + "," + country + "&APPID=" + APIKeys.openWeatherMap
        guard let url = URL(string: urlString) else {
            completionHandler(nil, "URL is not correct")
            return
        }
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                completionHandler(nil, error.localizedDescription)
                return
            }
            guard let data = data else {
                completionHandler(nil, "Invalid response data")
                return
            }
            do {
                guard let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any], let listArray = jsonDictionary["list"] as? [[String : Any]]/*, let weatherArray = jsonDictionary["weather"] as? [[String : Any]], let weatherDictionary = weatherArray.first, let windDictionary = jsonDictionary["wind"] as? [String : Any] */ else {
                    completionHandler(nil, "Response parse error")
                    return
                }
                var forecasts = [Forecast]()
                for listDictionary in listArray {
                    guard let mainDictionary = listDictionary["main"] as? [String : Any], let weatherArray = listDictionary["weather"] as? [[String : Any]], let weatherDictionary = weatherArray.first, let windDictionary = listDictionary["wind"] as? [String : Any], let date = listDictionary["dt_txt"] as? String else {
                        completionHandler(nil, "Response parse error")
                        return
                    }
                    let humidity = mainDictionary["humidity"] as? Int
                    let pressure = mainDictionary["pressure"] as? Float
                    let temp = mainDictionary["temp"] as? Float
                    let description = weatherDictionary["description"] as? String
                    let icon = weatherDictionary["icon"] as? String
                    let deg = windDictionary["deg"] as? Float
                    let speed = windDictionary["speed"] as? Float
                    let weather = Weather(temperature: temp, pressure: pressure, humidity: humidity, description: description, icon: icon, windDirection: deg, windSpeed: speed)
                    let forecast = Forecast(date: date, weather: weather)
                    forecasts.append(forecast)
                }
                forecasts = forecasts.filter({ $0.date.contains("15:00:00") || $0.date.contains("03:00:00") })
                completionHandler(forecasts, nil)
            } catch let error {
                completionHandler(nil, error.localizedDescription)
                return
            }
        }).resume()
    }
    
}
