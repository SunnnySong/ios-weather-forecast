//
//  CurrentWeatherViewModel.swift
//  WeatherForecast
//
//  Created by 김용재 on 2023/03/31.
//

import UIKit
import CoreLocation

final class CurrentWeatherViewModel {
    
    weak var delegate: CurrentWeatherViewModelDelegate?
    
    struct CurrentWeather {
        let image: UIImage?
        let address: String
        let temperatures: Temperature
    }
    
    func fetchCurrentAddress(locationManager: CoreLocationManager,
                             location: CLLocation) async throws -> String {
        
        let location = try await locationManager.changeGeocoder(location: location)
        
        guard let locality = location?.locality, let subLocality = location?.subLocality else {
            throw NetworkError.failedRequest
        }
        
        let address = "\(locality) \(subLocality)"
        
        return address
    }
    
    func fetchCurrentInformation(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                                 coordinate: Coordinate) async throws -> CurrentWeatherDTO {
        
        let decodedData = try await weatherNetworkDispatcher.requestWeatherInformation(of: .currentWeather, in: coordinate)
        
        guard let currentWeatherDTO = decodedData as? CurrentWeatherDTO else {
            throw NetworkError.failedDecoding
        }
        
        return currentWeatherDTO
    }
    
    func fetchCurrentImage(weatherNetworkDispatcher: WeatherNetworkDispatcher,
                           currentWeatherDTO: CurrentWeatherDTO) async throws -> UIImage {
        
        guard let iconString = currentWeatherDTO.weather.first?.icon else {
            throw NetworkError.failedRequest
        }
        let image = try await weatherNetworkDispatcher.requestWeatherImage(icon: iconString)
        
        guard let image = image else {
            throw NetworkError.emptyData
        }
        return image
    }
    
    func makeCurrentWeather(image: UIImage,
                            address: String,
                            currentWeatherDTO: CurrentWeatherDTO) -> CurrentWeather {
        
        let temperature = currentWeatherDTO.temperature
        let currentWeather = CurrentWeather(image: image, address: address, temperatures: temperature)
        return currentWeather
    }
}

