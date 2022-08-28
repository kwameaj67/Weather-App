//
//  CityService.swift
//  UdemyWeatherApp
//
//  Created by Kwame Agyenim - Boateng on 23/08/2022.
//

import Foundation
import Combine

class CityService{
    
    func fetchCity() -> AnyPublisher<CityResponse, Error> {
        guard let url = URL(string: Constants.URLs.cityUrl) else {
            fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: CityResponse.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .map { $0}
            .eraseToAnyPublisher()
    }
    
}
