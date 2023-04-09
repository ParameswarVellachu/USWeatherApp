//
//  WeatherApiService.swift
//  WeatherApp
//
//  Created by Rev on 08/04/23.
//

import Foundation
import CoreLocation

enum NetworkError: Error {
    case badUrl
    case noData
    case decodingError
}

struct APIResponse: Decodable {
    let name: String
    let main: APIMain
    let weather: [WeatherApiService]
}

struct APIMain: Decodable {
    let temp: Double
}

struct WeatherApiService: Decodable {
    let description: String
    let iconName: String
    
    enum CodingKeys: String, CodingKey {
        case description
        case iconName = "main"
    }
}

public final class WeatherService: NSObject {
    private let locationManager = CLLocationManager()
    private let API_KEY = "22628551c6ceddb0e3815b0ec6ea2be5"
    private var completionHandler: ((Weather) -> Void)?
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func loadWeatherData(_ completionHandler: @escaping(Weather) -> Void) {
        self.completionHandler = completionHandler
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getWeather(city: String, completionHandler: @escaping(Result<Weather?, NetworkError>) -> ()) {
    
        let urlString = "\(AppConstants.baseURl)q=\(city),US&appid=\(API_KEY)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completionHandler(.failure(.noData))
                return
            }
            
            let weatherResponse = try? JSONDecoder().decode(APIResponse.self, from: data)
            if let weatherResponse = weatherResponse {
                completionHandler(.success(Weather(response: weatherResponse)))
            } else {
                completionHandler(.failure(.noData))
            }
        }.resume()
    }
    
}

extension WeatherService: CLLocationManagerDelegate {
    
    func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        
        let urlString = "\(AppConstants.baseURl)lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { ( data, response, error ) in
            guard error == nil, let data = data else { return }
            
            if let response = try? JSONDecoder().decode(APIResponse.self, from: data) {
                self.completionHandler?(Weather(response: response))
            }
        }.resume()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        makeDataRequest(forCoordinates: location.coordinate)
    } 
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Something wrong: \(error.localizedDescription)")
    }
}

