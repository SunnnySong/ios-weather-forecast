//
//  WeatherController.swift
//  WeatherForecast
//
//  Created by Sunny on 2023/03/24.
//

/*
 - 연달아서 사용한 completionHandler 코드 대신 aync/await 코드 리팩토링
 */

import UIKit
import CoreLocation

final class WeatherController {
    
    struct CurrentWeather: Identifiable {
        let id = UUID()
        let image: UIImage?
        let address: String?
        let temperatures: Temperature?
    }
    
    struct FiveDaysForecast: Identifiable {
        let id = UUID()
        let image: UIImage
        let date: String
        let temperature: Double
    }
    
    private var weatherAPIManager: WeatherAPIManager?
    private let locationManager = LocationManager()
    var currentWeather: CurrentWeather?
    var fiveForecast: [FiveDaysForecast] = []
    
    weak var currentWeatherDelegate: CurrentWeatherDelegate?
    weak var fiveDaysForecastDelegate: FiveDaysForecastDelegate?
        
    init(networkModel: NetworkModel = NetworkModel(session: URLSession.shared)) {
        weatherAPIManager = WeatherAPIManager(networkModel: networkModel)
        
        locationManager.locationDelegate = self
    }
    
    func makeCoordinate(from location: CLLocation) -> Coordinate {
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        return Coordinate(longitude: longitude, latitude: latitude)
    }
    
    func makeCurrentWeather(location: CLLocation) {
        
        // 1. coordinate 주소 가져오기
        let coordinate = self.makeCoordinate(from: location)
        
        // 2. address 생성하기
        locationManager.changeGeocoder(location: location) { [weak self] place in
            
            guard let locality = place?.locality, let subLocality = place?.subLocality else { return }
            
            let address = "\(locality) \(subLocality)"
            
            // 3. currentWeather 가져오기
            self?.weatherAPIManager?.fetchWeatherInformation(of: .currentWeather, in: coordinate) { [weak self] data in
                let group = DispatchGroup()
                guard let weatherData = data as? CurrentWeatherDTO else { return }
                
                guard let icon = weatherData.weather.first?.icon else { return }
                
                group.enter()
                // 4. 이미지 가져오기
                self?.weatherAPIManager?.fetchWeatherImage(icon: icon) { [weak self] weatherImage in
                    
                    self?.currentWeather = CurrentWeather(image: weatherImage, address: address, temperatures: weatherData.temperature)
                    group.leave()
                }
                group.notify(queue: .main) {
                    self?.currentWeatherDelegate?.notifyToUpdateCurrentWeather()
                }
            }
        }
    }
    // notify
    func makeFiveDaysForcast(location: CLLocation) {
        
        // 좌표 만들기
        let coordinate = makeCoordinate(from: location)
        
        weatherAPIManager?.fetchWeatherInformation(of: .fiveDaysForecast, in: coordinate, completion: { data in
            guard let weatherData = data as? FiveDaysForecastDTO else { return }
            let group = DispatchGroup()
            let dayList = weatherData.list
            
            for day in dayList {
                let time = day.time
                let temperature = day.temperature.currentTemperature
                guard let iconString = day.weather.first?.icon else { return }
                group.enter()
                self.weatherAPIManager?.fetchWeatherImage(icon: iconString, completion: { iconImage in
                    guard let iconImage = iconImage else { return }
                    let fiveDaysForecast = FiveDaysForecast(image: iconImage, date: time, temperature: temperature)
                    self.fiveForecast.append(fiveDaysForecast)
                    group.leave()
                })
            }
            group.notify(queue: .main) {
//                self.
//                print(self.fiveForecast)
                self.fiveDaysForecastDelegate?.notifyToUpdateFiveDaysForecast()
            }
        })
        
    }
}


extension WeatherController: LocationDelegate {
    func send(location: CLLocation) {
        makeCurrentWeather(location: location)
        makeFiveDaysForcast(location: location)
    }
}
