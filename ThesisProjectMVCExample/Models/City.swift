//
//  CityWeather.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 25/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//
//
public struct CityForecast {
    public let cityCode: String
    public let cityName: String
    public let currentTemperature: Double
    public let assetCode: String
    public let lattLong: String
    public let weathers: [APIConsolidatedWeather]
}
//
//public struct City {
//    public let code: String
//    public let name: String
//    public let coordinates: Coordinates
//    public let currentTemperature: Double
//    public let asset: String
//    public let forecast: [Forecast]
//
//    public struct Coordinates {
//        public let lat: Double
//        public let lon: Double
//    }
//
//    public struct
//}
