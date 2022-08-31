//
//  WeatherService.swift
//  UdemyWeatherApp
//
//  Created by Kwame Agyenim - Boateng on 21/08/2022.
//

import Foundation
import Combine



class WeatherService {
    
    func fetchWeather(city: String) -> AnyPublisher<WeatherResponse,Error> {
        
        guard let url = URL(string: Constants.URLs.weather(for: city)) else {
            fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .catch { error in
                return Fail(error: error).eraseToAnyPublisher()
            }
            .map { $0.data }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)  // publisher would be returned on the main UI thread
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    
}
