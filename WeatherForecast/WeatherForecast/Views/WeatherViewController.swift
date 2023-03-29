//
//  WeatherForecast - WeatherViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
    
    private let networkModel = NetworkModel()
    private lazy var network = WeatherAPIManager(networkModel: networkModel)
    
    private var weatherController = WeatherController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherController.currentWeatherDelegate = self
    }
    
}

extension WeatherViewController: CurrentWeatherDelegate {
    
    func send(current: WeatherController.CurrentWeather) {
        print("viewController: \(current)")
    }
}

extension WeatherViewController: FiveDaysForecastDelegate {
    
    func send(fiveDaysForecast: WeatherController.FiveDaysForecast) {
        print("viewController: \(fiveDaysForecast)")
    }
}

