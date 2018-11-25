//
//  CityAdapter.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 26/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

public struct CityAdapter {
    private let apiForecast: APIForecast
    
    public init(apiForecast: APIForecast) {
        self.apiForecast = apiForecast
    }
    
    public func toCity() -> City {
        guard let firstWeather = apiForecast.consolidatedWeather.first else {
            fatalError("Fatal Error")
        }
        
        let adapter = ForecastAdapter(consolidatedWeather: apiForecast.consolidatedWeather)
        return City(code: String(apiForecast.parent.woeid),
                    name: apiForecast.title,
                    currentTemperature: firstWeather.theTemp,
                    asset: firstWeather.weatherStateAbbr,
                    latLon: apiForecast.lattLong,
                    forecastCollection: adapter.toForecastCollection())
    }
}
