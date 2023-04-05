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
                 let currentTemperature = currentWeather?.temperatures.temperature
           else { return }
           
           let addressAndTemperatureText: String = """
           \(address)
           최저 \(minimumTemperature)° 최소 \(maximumTemperature)°
           """
           
           let paragraphStyle = NSMutableParagraphStyle()
           paragraphStyle.lineSpacing = 6
           
           let addressAndTemperatureTextAttributes: [NSAttributedString.Key: Any] = [
               .font : UIFont.systemFont(ofSize: 13),
               .paragraphStyle : paragraphStyle
           ]
           
           configuration.attributedText = NSAttributedString(string: addressAndTemperatureText, attributes: addressAndTemperatureTextAttributes)
           
           let currentTemperatureText: String = "\(currentTemperature)°"
           let currentTemperatureTextAttribtues: [NSAttributedString.Key: Any] = [
               .font : UIFont.systemFont(ofSize: 30, weight: .semibold)
           ]
           
           configuration.secondaryAttributedText = NSAttributedString(string: currentTemperatureText, attributes: currentTemperatureTextAttribtues)
           
           configuration.textToSecondaryTextVerticalPadding = 10
           configuration.image = currentWeather?.image
           contentConfiguration = configuration
           
       }
}
