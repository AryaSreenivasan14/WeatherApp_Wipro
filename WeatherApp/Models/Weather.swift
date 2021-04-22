//
//  Weather.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 09/04/21.
//

import UIKit 

class Weather {
    var id:String = ""
    var name:String = ""
    var date:Double = 0
    var main:Main = Main([:])
    var sys:System = System([:])
    var currentWeather:CurrentWeather = CurrentWeather([:])
    
    init(_ dict:[String:Any]) {
        id   = dict.getIntAsString(key: "id")
        name = dict["name"] as? String ?? ""
        date = dict.getDouble(key: "dt")
        main = Main(dict["main"] as? [String:Any] ?? [:])
        sys  = System(dict["sys"] as? [String:Any] ?? [:])
        
        
        let currentWeatherArray  = dict["weather"] as? [[String:Any]] ?? []
        if (currentWeatherArray.count > 0) {
            currentWeather = CurrentWeather(currentWeatherArray[0])
        }
    }
}

class Main {
    var temp:String = ""
    var temp_min:String = ""
    var temp_max:String = ""
    var humidity:String = ""
    init(_ dict:[String:Any]) {
        temp = dict.getDouble(key: "temp").roundedToString(toPlaces: 0)
        temp_min = dict.getDouble(key: "temp_min").roundedToString(toPlaces: 0)
        temp_max = dict.getDouble(key: "temp_max").roundedToString(toPlaces: 0)
        humidity = dict.getDouble(key: "humidity").roundedToString(toPlaces: 0)
    }
}

class System {
    var country:String = ""
    var sunrise:Double = 0
    var sunset:Double = 0
    init(_ dict:[String:Any]) {
        country = dict["country"] as? String ?? ""
        sunrise = dict.getDouble(key: "sunrise")
        sunset = dict.getDouble(key: "sunset")
    }
}

class CurrentWeather {
    var icon:String = ""
    var main:String = ""
    var description:String = ""
    init(_ dict:[String:Any]) {
        icon = dict["icon"] as? String ?? ""
        main = dict["main"] as? String ?? ""
        description = dict["description"] as? String ?? ""
    }
}
