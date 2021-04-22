//
//  HomeViewTableCellModel.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 09/04/21.
//

import UIKit

class HomeViewTableCellModel: NSObject {
    let identifier = "weatherCell"
    
    func getCityName(allCities:[City], cityId:String) ->String {
        let city = allCities.filter{$0.id == cityId}
        if (city.count > 0) {
            return city.first?.name ?? ""
        }
        return ""
    }
    
    func getCountryName(allCities:[City], cityId:String) ->String {
        let city = allCities.filter{$0.id == cityId}
        if (city.count > 0) {
            return city.first?.country ?? ""
        }
        return ""
    }
    
    //MARK:- API Call
    func getDataFromServer(cityId:String, responseCache:[String:Weather], completion: @escaping (Weather, _ error:Error?) -> ()) {
        
        if let cachedItem = responseCache[cityId] {
            completion(cachedItem,nil)
            return
        }
        
        ApiManager().fetchWeatherDetails(cityId: cityId) { (resposneDict, error) in
            if let error = error {
                completion(Weather([:]),error)
            }else {
                let weather = Weather(resposneDict)
                completion(weather,nil)
            }
        }
    }
    
    func getCountryAndTimeName(weather:Weather) ->String {
        let country = weather.sys.country
        let time = "\(weather.date)".getDateStringFromUnixTimeStamp(format: ConstantStrings.DATEFORMAT_dd_MMM_hh_mm_a)
        return country+ConstantStrings.COMA_AND_SPACE+time
    }
    
    func getTemperature(weather:Weather) ->String {
        return weather.main.temp+ConstantStrings.CURRENCY_SYMBOL
    }
    
    func getWeatherIconUrlString(weather:Weather) -> String {
        return API.ICON_ROOT.replacingOccurrences(of: ConstantStrings.ICON_PLACEHOLDER, with: weather.currentWeather.icon).replacingOccurrences(of: " ", with: ConstantStrings.PERCENTAGE_20)
    }
}
