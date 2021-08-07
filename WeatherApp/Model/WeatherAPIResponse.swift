//
//  WeatherAPIResponse.swift
//  WeatherApp
//
//  Created by Shivi Agarwal on 05/08/21.
//

import Foundation

struct WeatherAPIResponse: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
}

struct Main: Decodable {
    let temp: Double
}

struct Weather: Decodable {
    let id: Int
}
