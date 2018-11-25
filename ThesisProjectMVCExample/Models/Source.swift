//
//  Source.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 25/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

public struct Source: Codable {
    public let title, slug: String
    public let url: String
    public let crawlRate: Int
    
    public enum CodingKeys: String, CodingKey {
        case title, slug, url
        case crawlRate = "crawl_rate"
    }
}
