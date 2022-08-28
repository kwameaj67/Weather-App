//
//  Weather.swift
//  UdemyWeatherApp
//
//  Created by Kwame Agyenim - Boateng on 21/08/2022.
//

import Foundation

enum WeatherCondition{
    case clouds
    case clear
    case snow
    case rain
    case drizzle
    case thunderstorm
    case atmosphere
}

struct WeatherResponse: Decodable {
    let weather: [WeatherInformation]?
    let main: Weather?
    let wind: WeatherWind?
    
    static var placeholder: WeatherResponse {
        return WeatherResponse(weather: nil, main: nil,wind: nil)
    }
}

struct Weather: Decodable {
    
    let temp: Double?  // current temperature
    let humidity: Double?
    let pressure: Double?
    
    static var placeholder: Weather {
        return Weather(temp: nil, humidity: nil, pressure: nil)
    }
    
}

struct WeatherInformation: Decodable {
    var description: String?
    var main: String?
}

struct WeatherWind: Decodable {
    var speed: Double?
}
