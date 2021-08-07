//
//  ViewController.swift
//  WeatherApp
//
//  Created by Shivi Agarwal on 05/08/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {

    let weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        searchTextField.delegate = self
        weatherManager.delegate = self
        
    }


    @IBAction func searchButtonTapped(_ sender: UIButton) {
        
        searchTextField.endEditing(true)
        searchTextField.text = ""
        let text = searchTextField.text!
        print(text)
    }
    
    @IBAction func locationButtonTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

extension WeatherViewController: UITextFieldDelegate
{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        textField.text = ""
        print(searchTextField.text!)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""
        {
            return true
        }
        
        else
        {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = textField.text
        {
            weatherManager.fetchWeatherData(city: city)
        }
    }
}

extension WeatherViewController: WeatherManagerDelegate
{
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.sync {
            temperatureLabel.text = weather.temperatureString
            weatherImage.image = UIImage(systemName: weather.conditionName)
            cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithWeather(error: Error) {
        let alert = UIAlertController(title: "Oops!!", message: "Unable to get the weather data. Please try again after sometime.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       if let location = locations.last
       {
        locationManager.stopUpdatingLocation()
        let lat = location.coordinate.latitude
        let lon = location.coordinate.longitude
        weatherManager.fetchWeatherData(latitude: lat, longitude: lon)
       }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

