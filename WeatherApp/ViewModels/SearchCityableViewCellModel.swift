//
//  SearchTCityableViewCellModel.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 10/04/21.
//

import UIKit

class SearchCityableViewCellModel: NSObject {
    let identifier = "searchCell"
    
    func getCityName(city:City) ->String {
        return city.name
    }
    
    func getCountryName(city:City) ->String {
        return city.country
    }
    
    
}
