//
//  USWeatherAppApp.swift
//  USWeatherApp
//
//  Created by Rev on 09/04/23.
//

import SwiftUI

@main
struct USWeatherAppApp: App {
    var body: some Scene {
        WindowGroup {
            let weatherService = WeatherService()
            let vm = WeatherViewModel(weatherService: weatherService)
            WeatherView(vm: vm)
        }
    }
}
