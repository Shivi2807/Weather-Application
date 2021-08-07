//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Shivi Agarwal on 05/08/21.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithWeather(error: Error)
}

class WeatherManager
{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?&appid=2bd1ad4fd6a0a43e11faee97e4e218cf&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeatherData(city: String)
    {
        guard let completeUrl = URL(string: "\(weatherURL)&q=\(city)") else
        {
            print("Unable to get complete url")
            return
        }
        
        performRequest(with: completeUrl)
       
    }
    
    func fetchWeatherData(latitude: Double, longitude: Double)
    {
        guard let completeUrl = URL(string: "\(weatherURL)&lat=\(latitude)&lon=\(longitude)") else
        {
            print("Unable to get complete url")
            return
        }
        
     performRequest(with: completeUrl)
        
    }
    
    func performRequest(with url: URL) {
        
        let session = URLSession(configuration: .default)
        let _ = session.dataTask(with: url) { [weak self] data, response , error in
            if error == nil
            {
                let response = response as! HTTPURLResponse
                if (response.statusCode == 200)
                {
                    if let safeData = data
                    {
                        if let weather = self?.parseJSON(safeData)
                        {
                            self?.delegate?.didUpdateWeather(weather: weather)
                        }
                    }
                }
            }
        }.resume()
    }
    
    func parseJSON(_ weatherData: Data)-> WeatherModel?
    {
        let decoder = JSONDecoder()
        do{
        let decodedData = try decoder.decode(WeatherAPIResponse.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(cityName: name, cityTemp: temp, conditionId: id)
            return weather
        }
        catch{
            delegate?.didFailWithWeather(error: error)
            return nil
            
        }
    }
}
