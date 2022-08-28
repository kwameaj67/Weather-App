//
//  Constants.swift
//  UdemyWeatherApp
//
//  Created by Kwame Agyenim - Boateng on 21/08/2022.
//

import Foundation


struct Constants{
    
    struct URLs{
        static let apiKey = "08cbb4e7ba48807c9d986516a8af841d"        
        static func weather(for city: String) -> String {
            return "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        }
        static let cityUrl = "https://countriesnow.space/api/v0.1/countries/population/cities"
    }
}
