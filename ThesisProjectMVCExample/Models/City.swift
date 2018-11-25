//
//  CityWeather.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 25/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//
//

public struct City: Equatable {    
    public let code: String
    public let name: String
    public let coordinates: Coordinates
    public let brief: Brief
    public let forecastCollection: [Forecast]

    public struct Coordinates: Equatable {
        public let lat: Double
        public let lon: Double
    }

    public struct Brief: Equatable {
        public let currentTemperature: Double
        public let asset: String
    }
    
    public init(code: String,
                name: String,
                currentTemperature: Double,
                asset: String,
                latLon: String,
                forecastCollection: [Forecast]) {
        self.code = code
        self.name = name
        self.coordinates = CoordinatesAdapter(latLon: latLon).toCoordinates()
        self.brief = Brief(currentTemperature: currentTemperature, asset: asset)
        self.forecastCollection = forecastCollection
    }
}
