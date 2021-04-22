//
//  DetailTableViewCellModel.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 10/04/21.
//

import UIKit

class DetailTableViewCellModel: NSObject {
    let identifier = "detailsCell"

    func getCityName(weather:Weather) ->String {
        return weather.name
    }
    
    func getMinTemperature(weather:Weather) ->String {
        return weather.main.temp_min+"°"
    }
    
    func getMaxTemperature(weather:Weather) ->String {
        return weather.main.temp_max+"°"
    }
    
    func getCurrentWeatherCondition(weather:Weather) ->String {
        let outsideTime = ((weather.date > weather.sys.sunset) ? OutsideTime.Night : OutsideTime.Day).rawValue
        return weather.currentWeather.main+" (\(outsideTime))"
    }
    
    func getHumidity(weather:Weather) ->String{
        "Humidity: "+weather.main.humidity
    }
     
    func getTemperature(weather:Weather) ->String {
        return weather.main.temp+ConstantStrings.CURRENCY_SYMBOL
    }
    
    func getWeatherIconUrlString(weather:Weather) -> String {
        return API.ICON_ROOT.replacingOccurrences(of: ConstantStrings.ICON_PLACEHOLDER, with: weather.currentWeather.icon).replacingOccurrences(of: " ", with: ConstantStrings.PERCENTAGE_20)
    }
    
    func getCellHeight(tableView:UITableView) ->CGFloat {
        if UIDevice.current.orientation.isLandscape {
            return tableView.frame.size.height + 100
        } else {
            return tableView.frame.size.height
        }
    }
}
