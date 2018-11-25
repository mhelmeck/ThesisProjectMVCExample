//
//  WeatherAdapter.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 25/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

//public struct WeatherAdapter {
//    private let consolidatedWeather: ConsolidatedWeather
//
//    public init(consolidatedWeather: ConsolidatedWeather) {
//        self.consolidatedWeather = consolidatedWeather
//    }
//
//    public func toWeather() -> Forecast {
//        return Weather(type: consolidatedWeather.weatherStateName,
//                       assetCode: consolidatedWeather.weatherStateAbbr,
//                       windDirection: consolidatedWeather.windDirectionCompass,
//                       date: consolidatedWeather.applicableDate,
//                       minTemperature: consolidatedWeather.minTemp,
//                       maxTemperature: consolidatedWeather.maxTemp,
//                       currentTemperature: consolidatedWeather.theTemp,
//                       windSpeed: consolidatedWeather.windSpeed,
//                       airPressure: consolidatedWeather.airPressure)
//    }
//}
