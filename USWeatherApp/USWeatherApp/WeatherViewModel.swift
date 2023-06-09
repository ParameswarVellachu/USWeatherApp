//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Rev on 08/04/23.
//

import Foundation

protocol CityProtocol {
    func fetchWeather(by city: String)
}

enum LoadingState {
    case none
    case loading
    case success
    case failed
}

private let defaultIcon = " ? "
private let iconMap = ["Drizzle": "🌧", "Thunderstorm": "⛈", "Rain": "🌧", "Snow": "🌨", "Clear": "☀️", "Clouds": "☁️"]

public class WeatherViewModel: ObservableObject {
    
    var cityNam: String = ""
    
    let cityProtocol: CityProtocol? = nil
    
    @Published var message: String = ""
    @Published var loadingState: LoadingState = .none
    
    @Published var cityName: String = "New York"
    @Published var temperature: String = "--"
    @Published var weatherDescription: String = "--"
    @Published var weatherIcon: String = defaultIcon
    
    public let weatherService: WeatherService
    
    public init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    init() {
        self.weatherService = WeatherService()
    }
    
    func search() {
        if let city = self.cityNam.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
            fetchWeather(by: city)
        }
    }
        
    public func refresh() {
        self.loadingState = .loading
        weatherService.loadWeatherData { weather in
            DispatchQueue.main.async {
                self.cityName = weather.city
                self.temperature = "\(weather.temperature)˚C"
                self.weatherDescription = weather.description.capitalized
                self.weatherIcon = iconMap[weather.iconName] ?? defaultIcon
                self.loadingState = .success
               
            }
        }
    }
}

extension WeatherViewModel: CityProtocol {
    
    func fetchWeather(by city: String) {
        self.loadingState = .loading
        self.weatherService.getWeather(city: city) { result in
            switch result {
            case .success(let weather):
                DispatchQueue.main.async {
                    if let temperature = weather?.temperature {
                        self.cityName = weather?.city ?? ""
                        self.temperature = "\(temperature)˚C"
                        self.weatherDescription = weather?.description.capitalized ?? ""
                        self.weatherIcon = iconMap[weather?.iconName ?? defaultIcon] ?? defaultIcon
                        self.loadingState = .success
                    }
                }
            case .failure(_ ):
                DispatchQueue.main.async {
                    self.message = "Unable to find the city.."
                    self.loadingState = .failed
                }
            }
        }
    }
}
