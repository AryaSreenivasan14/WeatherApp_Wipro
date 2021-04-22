//
//  DefaultWrapper.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 09/04/21.
//

import UIKit

class DefaultWrapper: NSObject {
    let defaultCities:[String] = ["2158177", "2147714", "2174003"]
    
    func addNewCity(cityId:String) {
        var savedCityIds = self.savedCityIds()
        if (!savedCityIds.contains(cityId)) {
            savedCityIds.append(cityId)
        }
        UserDefaults.standard.setValue(savedCityIds, forKey: "SAVED_CITY_IDS")
    }
    
    func removeNewCity(cityId:String) {
        let savedCityIds = self.savedCityIds().filter{$0 != cityId}
        UserDefaults.standard.setValue(savedCityIds, forKey: "SAVED_CITY_IDS")
    }
    
    func savedCityIds() ->[String] {
        return UserDefaults.standard.value(forKey: "SAVED_CITY_IDS") as? [String] ?? defaultCities
    }
}
