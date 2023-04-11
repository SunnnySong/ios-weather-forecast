//
//  CurrentWeatherCell.swift
//  WeatherForecast
//
//  Created by 송선진 on 2023/04/05.
//

import UIKit

final class CurrentWeatherCell: UICollectionViewListCell {
    
    var currentWeather: CurrentWeatherViewModel.CurrentWeather?
       
       override func updateConfiguration(using state: UICellConfigurationState) {
           super.updateConfiguration(using: state)
           
           var configuration = UIListContentConfiguration.subtitleCell()
           
           guard let address = currentWeather?.address,
                 let minimumTemperature = currentWeather?.temperatures.minimumTemperature,
                 let maximumTemperature = currentWeather?.temperatures.maximumTemperature,
                 let currentTemperature = currentWeather?.temperatures.averageTemperature
           else { return }
           
           let minimumTemperatureText = String(format: "%.1f", minimumTemperature)
           let maximumTemperatureText = String(format: "%.1f", maximumTemperature)

           let addressAndTemperatureText: String = """
           \(address)
           최저 \(minimumTemperatureText)° 최소 \(maximumTemperatureText)°
           """
           
           let paragraphStyle = NSMutableParagraphStyle()
           paragraphStyle.lineSpacing = 6
           
           let addressAndTemperatureTextAttributes: [NSAttributedString.Key: Any] = [
               .font : UIFont.systemFont(ofSize: 13),
               .paragraphStyle : paragraphStyle,
           ]
           
           configuration.attributedText = NSAttributedString(string: addressAndTemperatureText,
                                                             attributes: addressAndTemperatureTextAttributes)
           configuration.textProperties.color = .white
           
           let currentTemperatureValue = String(format: "%.1f", currentTemperature)
           let currentTemperatureText: String = "\(currentTemperatureValue)°"
           let currentTemperatureTextAttribtues: [NSAttributedString.Key: Any] = [
               .font : UIFont.systemFont(ofSize: 30, weight: .semibold)
           ]
           
           configuration.secondaryAttributedText = NSAttributedString(string: currentTemperatureText,
                                                                      attributes: currentTemperatureTextAttribtues)
           configuration.secondaryTextProperties.color = .white
           configuration.textToSecondaryTextVerticalPadding = 10
           
           configuration.image = currentWeather?.image
           
           contentConfiguration = configuration
       }
}

protocol MakeAlertDelegate: AnyObject {
    
    func alertDelegate()
}