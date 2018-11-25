//
//  WeatherAdapter.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 25/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

public struct ForecastAdapter {
    private let consolidatedWeather: [APIConsolidatedWeather]

    public init(consolidatedWeather: [APIConsolidatedWeather]) {
        self.consolidatedWeather = consolidatedWeather
    }

    public func toForecastCollection() -> [Forecast] {
        var forecastCollection = [Forecast]()
        consolidatedWeather.forEach {
             forecastCollection.append(
                Forecast(type: $0.weatherStateName,
                         assetCode: $0.weatherStateAbbr,
                         windDirection: $0.windDirectionCompass,
                         date: $0.applicableDate,
                         minTemperature: $0.minTemp,
                         maxTemperature: $0.maxTemp,
                         currentTemperature: $0.theTemp,
                         windSpeed: $0.windSpeed,
                         airPressure: $0.airPressure)
            )
        }
        
        return forecastCollection
    }
}
