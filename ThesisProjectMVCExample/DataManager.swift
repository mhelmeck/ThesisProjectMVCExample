//
//  DataManager.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 25/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

import Foundation

public struct CityWeather {
    public let cityCode: String
    public let cityName: String
    public let temperature: Double
    public let assetType: String
    public let lattLong: String
    public let weather: [ConsolidatedWeather]
}

public class DataManager {
    public var cityCodes: [String] = ["44418", "4118", "804365"]
    public var locations = [Parent]()
    public var forecast = [CityWeather]()
    
    public func fetchForecast(forCityCode code: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://www.metaweather.com/api/location/\(code)/") else {
            assertionFailure("URL init failed")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let cityForecast = try decoder.decode(Forecast.self, from: data)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    guard let firstDayCityForecast = cityForecast.consolidatedWeather.first else {
                        return
                    }
                    
                    let cityCode = code
                    let cityName = cityForecast.title
                    let weather = cityForecast.consolidatedWeather
                    let temperature = firstDayCityForecast.theTemp
                    let assetType = firstDayCityForecast.weatherStateAbbr
                    let lattLong: String = cityForecast.lattLong
                    let cityWeather = CityWeather(cityCode: cityCode,
                                                  cityName: cityName,
                                                  temperature: temperature,
                                                  assetType: assetType,
                                                  lattLong: lattLong,
                                                  weather: weather)
                    
                    if !self.cityCodes.contains(cityCode) {
                        self.cityCodes.append(cityCode)
                    }
                    
                    let duplicatedForecast = self.forecast.filter { $0.cityCode == cityCode }
                    if duplicatedForecast.isEmpty {
                        self.forecast.append(cityWeather)
                    }
                    
                    completion()
                }
                
            } catch let error {
                print("Error: ", error)
            }
        }.resume()
    }
    
    public func fetchLocation(withLatLon lat: String, _ lon: String, completion: @escaping ([Parent]) -> ()) {
        guard let url = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(lat),\(lon)") else {
            assertionFailure("URL init failed")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let locations = try decoder.decode([Parent].self, from: data)
                DispatchQueue.main.async {
                    completion(locations)
                }
                
            } catch let error {
                print("Error: ", error)
            }
        }.resume()
    }
    
    public func fetchLocations(withQuery query: String, completion: @escaping () -> ()) {
        let formattedQuery = query.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: "https://www.metaweather.com/api/location/search/?query=\(formattedQuery)") else {
            assertionFailure("URL init failed")
            return
        }
        
        fetchLocations(withURL: url, completion: completion)
    }
    
    public func fetchLocations(withLatLon lat: String, _ lon: String, completion: @escaping () -> ()) {
        guard let url = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(lat),\(lon)") else {
            assertionFailure("URL init failed")
            return
        }
        
        fetchLocations(withURL: url, completion: completion)
    }
    
    private func fetchLocations(withURL url: URL, completion: @escaping () -> ()) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let locations = try decoder.decode([Parent].self, from: data)
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else {
                        return
                    }
                    
                    self.locations = locations
                    completion()
                }
                
            } catch let error {
                print("Error: ", error)
            }
            }.resume()
    }
}
