//
//  DatabaseManager.swift
//  WeatherTest
//
//  Created by Sergey Kobzin on 31.01.2018.
//  Copyright © 2018 Sergey Kobzin. All rights reserved.
//

import CoreData
import UIKit

class DatabaseManager {
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    fileprivate static func getCityEntity(forCity city: City, completionHandler: (CityEntity?) -> ()) {
        let fetchRequest = NSFetchRequest<CityEntity>(entityName: "CityEntity")
        fetchRequest.predicate = NSPredicate(format: "name == %@ && country == %@ && latitude == %@ && longitude == %@", city.name, city.country, city.latitude, city.longitude)
        do {
            let fetchedCityEntities = try context.fetch(fetchRequest)
            let cityEntity = fetchedCityEntities.first
            completionHandler(cityEntity)
            return
        } catch let error {
            print(error.localizedDescription)
            completionHandler(nil)
            return
        }
    }
    
    static func getForecastEntities(forCity city: City, completionHandler: ([ForecastEntity]?) -> ()) {
        getCityEntity(forCity: city, completionHandler: { (cityEntity) in
            guard let cityEntity = cityEntity, let forecasts = cityEntity.forecasts else {
                completionHandler(nil)
                return
            }
            let forecastEntities = Array(forecasts) as? [ForecastEntity]
            completionHandler(forecastEntities)
            return
        })
    }
    
    static func getCities(completionHandler: ([City]?) -> ()) {
        let fetchRequest = NSFetchRequest<CityEntity>(entityName: "CityEntity")
        do {
            let fetchedCityEntities = try context.fetch(fetchRequest)
            var cities = [City]()
            for cityEntity in fetchedCityEntities {
                guard let name = cityEntity.name, let country = cityEntity.country, let latitude = cityEntity.latitude, let longitude = cityEntity.longitude else { continue }
                let city = City(name: name, country: country, latitude: latitude, longitude: longitude)
                cities.append(city)
            }
            completionHandler(cities)
            return
        } catch let error {
            print(error.localizedDescription)
            completionHandler(nil)
            return
        }
    }
    
    static func addCity(city: City, completionHandler: (Bool) -> ()) {
        getCityEntity(forCity: city, completionHandler: { (cityEntity) in
            if cityEntity != nil {
                completionHandler(true)
                return
            }
            let cityEntity = CityEntity(entity: CityEntity.entity(), insertInto: context)
            cityEntity.name = city.name
            cityEntity.country = city.country
            cityEntity.latitude = city.latitude
            cityEntity.longitude = city.longitude
            do {
                try context.save()
                completionHandler(true)
                return
            } catch let error {
                print(error.localizedDescription)
                completionHandler(false)
                return
            }
        })
    }
    
    static func removeCity(city: City, completionHandler: (Bool) -> ()) {
        getCityEntity(forCity: city, completionHandler: { (cityEntity) in
            guard let cityEntity = cityEntity else {
                completionHandler(true)
                return
            }
            context.delete(cityEntity)
            do {
                try context.save()
                completionHandler(true)
                return
            } catch let error {
                print(error.localizedDescription)
                completionHandler(false)
                return
            }
        })
    }
    
    static func getWeather(forCity city: City, completionHandler: (Weather?) -> ()) {
        getCityEntity(forCity: city, completionHandler: { (cityEntity) in
            guard let cityEntity = cityEntity, let weatherEntity = cityEntity.weather else {
                completionHandler(nil)
                return
            }
            let temperature = weatherEntity.temperature
            let pressure = weatherEntity.pressure
            let humidity = weatherEntity.humidity
            let description = weatherEntity.descriptio
            let icon = weatherEntity.icon
            let windDirection = weatherEntity.windDirection
            let windSpeed = weatherEntity.windSpeed
            let weather = Weather(temperature: temperature, pressure: pressure, humidity: humidity, description: description, icon: icon, windDirection: windDirection, windSpeed: windSpeed)
            completionHandler(weather)
            return
        })
    }
    
    static func addWeather(weather: Weather, forCity city: City, completionHandler: (Bool) -> ()) {
        getCityEntity(forCity: city, completionHandler: { (cityEntity) in
            guard let cityEntity = cityEntity else {
                completionHandler(false)
                return
            }
            let weatherEntity = cityEntity.weather ?? WeatherEntity(entity: WeatherEntity.entity(), insertInto: context)
            weatherEntity.temperature = weather.temperature
            weatherEntity.pressure = weather.pressure
            weatherEntity.humidity = weather.humidity
            weatherEntity.descriptio = weather.description
            weatherEntity.icon = weather.icon
            weatherEntity.windDirection = weather.windDirection
            weatherEntity.windSpeed = weather.windSpeed
            weatherEntity.city = cityEntity
            do {
                try context.save()
                completionHandler(true)
                return
            } catch let error {
                print(error.localizedDescription)
                completionHandler(false)
                return
            }
        })
    }
    
    static func removeWeather(forCity city: City, completionHandler: (Bool) -> ()) {
        getCityEntity(forCity: city, completionHandler: { (cityEntity) in
            guard let cityEntity = cityEntity, let weatherEntity = cityEntity.weather else {
                completionHandler(true)
                return
            }
            context.delete(weatherEntity)
            do {
                try context.save()
                completionHandler(true)
                return
            } catch let error {
                print(error.localizedDescription)
                completionHandler(false)
                return
            }
        })
    }
    
    static func getForecasts(forCity city: City, completionHandler: ([Forecast]?) -> ()) {
        getCityEntity(forCity: city, completionHandler: { (cityEntity) in
            guard let cityEntity = cityEntity, let forecastsRelationship = cityEntity.forecasts, let forecastEntities = Array(forecastsRelationship) as? [ForecastEntity] else {
                completionHandler(nil)
                return
            }
            var forecasts = [Forecast]()
            for forecastEntity in forecastEntities {
                guard let date = forecastEntity.date, let weatherEntity = forecastEntity.weather else { continue }
                let temperature = weatherEntity.temperature
                let pressure = weatherEntity.pressure
                let humidity = weatherEntity.humidity
                let description = weatherEntity.descriptio
                let icon = weatherEntity.icon
                let windDirection = weatherEntity.windDirection
                let windSpeed = weatherEntity.windSpeed
                let weather = Weather(temperature: temperature, pressure: pressure, humidity: humidity, description: description, icon: icon, windDirection: windDirection, windSpeed: windSpeed)
                let forecast = Forecast(date: date, weather: weather)
                forecasts.append(forecast)
            }
            completionHandler(forecasts)
            return
        })
    }
    
    static func addForecasts(forecasts: [Forecast], forCity city: City, completionHandler: (Bool) -> ()) {
        getCityEntity(forCity: city, completionHandler: { (cityEntity) in
            guard let cityEntity = cityEntity else {
                completionHandler(false)
                return
            }
            removeForecasts(forCity: city, completionHandler: { (success) in
                if !success {
                    completionHandler(false)
                    return
                }
                for forecast in forecasts {
                    let weather = forecast.weather
                    let weatherEntity = WeatherEntity(entity: WeatherEntity.entity(), insertInto: context)
                    weatherEntity.temperature = weather.temperature
                    weatherEntity.pressure = weather.pressure
                    weatherEntity.humidity = weather.humidity
                    weatherEntity.descriptio = weather.description
                    weatherEntity.icon = weather.icon
                    weatherEntity.windDirection = weather.windDirection
                    weatherEntity.windSpeed = weather.windSpeed
                    let forecastEntity = ForecastEntity(entity: ForecastEntity.entity(), insertInto: context)
                    forecastEntity.date = forecast.date
                    forecastEntity.weather = weatherEntity
                    forecastEntity.city = cityEntity
                }
            })
            do {
                try context.save()
                completionHandler(true)
                return
            } catch let error {
                print(error.localizedDescription)
                completionHandler(false)
                return
            }
        })
    }
    
    static func removeForecasts(forCity city: City, completionHandler: (Bool) -> ()) {
        getCityEntity(forCity: city, completionHandler: { (cityEntity) in
            guard let cityEntity = cityEntity, let forecastsRelationship = cityEntity.forecasts, let forecastEntities = Array(forecastsRelationship) as? [ForecastEntity] else {
                completionHandler(true)
                return
            }
            for forecastEntity in forecastEntities {
                context.delete(forecastEntity)
            }
            do {
                try context.save()
                completionHandler(true)
                return
            } catch let error {
                print(error.localizedDescription)
                completionHandler(false)
                return
            }
        })
    }
    
}
