//
//  AppConstants.swift
//  USWeatherApp
//
//  Created by Rev on 09/04/23.
//

import Foundation

public struct AppConstants {
    static var baseURl: URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/weather?")!
    }
}
