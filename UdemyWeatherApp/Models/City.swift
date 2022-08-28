//
//  City.swift
//  UdemyWeatherApp
//
//  Created by Kwame Agyenim - Boateng on 23/08/2022.
//

import Foundation

struct CityResponse : Decodable{
    var data: [City]
}

struct City : Decodable {
    var country: String?
    var city: String?
}
