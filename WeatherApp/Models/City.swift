//
//  City.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 09/04/21.
//

import UIKit

class City {
    var id:String = ""
    var name:String = ""
    var state:String = ""
    var country:String = ""
    var coord:Coordinates = Coordinates([:])
    
    init(_ dict:[String:Any]) {
        id      = dict.getIntAsString(key: "id")
        name    = dict["name"] as? String ?? ""
        state   = dict["state"] as? String ?? ""
        country = dict["country"] as? String ?? ""
        coord   = Coordinates(dict["coord"] as? [String:Any] ?? [:])
    }
}

class Coordinates {
    var lat:Double = 0.0
    var lon:Double = 0.0
    
    init(_ dict:[String:Any]) {
        lat = dict.getDouble(key: "lat")
        lon = dict.getDouble(key: "lon")
    }
}
