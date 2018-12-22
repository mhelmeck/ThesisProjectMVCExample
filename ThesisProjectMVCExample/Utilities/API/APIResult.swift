//
//  APIResult.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 29/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

public enum APIResult<T> {
    case success(T)
    case error(Error)
}
public typealias APIResultHandler<T> = (APIResult<T>) -> Void
