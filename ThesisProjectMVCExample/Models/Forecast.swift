//
//  Forecast.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 25/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

public struct Forecast: Codable {
    public let consolidatedWeather: [ConsolidatedWeather]
    public let time: String
    public let sunRise: String
    public let sunSet: String
    public let timezoneName: String
    public let parent: Parent
    public let sources: [Source]
    public let title: String
    public let locationType: String
    public let woeid: Int
    public let lattLong: String
    public let timezone: String
    
    public enum CodingKeys: String, CodingKey {
        case consolidatedWeather = "consolidated_weather"
        case time
        case sunRise = "sun_rise"
        case sunSet = "sun_set"
        case timezoneName = "timezone_name"
        case parent, sources, title
        case locationType = "location_type"
        case woeid
        case lattLong = "latt_long"
        case timezone
    }
}
