//
//  DataManager.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 25/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

import Foundation

public enum APIResult<T> {
    case success(T)
    case error(Error)
}
public typealias APIResultHandler<T> = (APIResult<T>) -> Void

public class DataManager {
    public var cityCodes: [String] = ["44418", "4118", "804365"]
    public var locations = [APIParent]()
    public var cityCollection = [City]()
    
    public func fetchForecast(forCityCode code: String, completion: @escaping () -> Void) {
        guard let url = URL(string: "https://www.metaweather.com/api/location/\(code)/") else {
            assertionFailure("URL init failed")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data else {
                return
            }
            
            do {
                guard let self = self else {
                    return
                }
                
                let decoder = JSONDecoder()
                let apiForecast = try decoder.decode(APIForecast.self, from: data)

                let adapter = CityAdapter(apiForecast: apiForecast)
                let city = adapter.toCity()
                
                if !self.cityCodes.contains(city.code) {
                    self.cityCodes.append(city.code)
                }
                
                let duplications = self.cityCollection.filter { $0.code == city.code }
                if duplications.isEmpty {
                    self.cityCollection.append(city)
                }
                
                DispatchQueue.main.async {
                    completion()
                }
                
            } catch let error {
                print("Error: ", error)
            }
        }.resume()
    }

    public func fetchLocation(withLatLon lat: String, _ lon: String, completion: @escaping ([APIParent]) -> Void) {
        guard let url = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(lat),\(lon)") else {
            assertionFailure("URL init failed")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let locations = try decoder.decode([APIParent].self, from: data)
                DispatchQueue.main.async {
                    completion(locations)
                }
                
            } catch let error {
                print("Error: ", error)
            }
        }.resume()
    }
    
    public func fetchLocations(withQuery query: String, completion: @escaping () -> Void) {
        let formattedQuery = query.replacingOccurrences(of: " ", with: "%20")
        guard let url = URL(string: "https://www.metaweather.com/api/location/search/?query=\(formattedQuery)") else {
            assertionFailure("URL init failed")
            return
        }
        
        fetchLocations(withURL: url, completion: completion)
    }
    
    public func fetchLocations(withLatLon lat: String, _ lon: String, completion: @escaping () -> Void) {
        guard let url = URL(string: "https://www.metaweather.com/api/location/search/?lattlong=\(lat),\(lon)") else {
            assertionFailure("URL init failed")
            return
        }
        
        fetchLocations(withURL: url, completion: completion)
    }
    
    private func fetchLocations(withURL url: URL, completion: @escaping () -> Void) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let locations = try decoder.decode([APIParent].self, from: data)
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
