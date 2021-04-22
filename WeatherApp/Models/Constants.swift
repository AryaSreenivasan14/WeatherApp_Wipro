//
//  Constants.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 09/04/21.
//

import UIKit

//MARK:- Common constant strings
struct ConstantStrings {
    
    //Alert
    static let EMPTY = ""
    static let PERCENTAGE_20 = "%20"
    static let INVALID_URL = "Invalid URL"
    static let NO_NETWORK  = "Please check your internet connection"
    static let ICON_PLACEHOLDER = "ICON_PLACEHOLDER"
    static let LOCALIZED_ERROR = "localizedDescription"
    static let CURRENCY_SYMBOL = "°C"
    static let COMA_AND_SPACE = ", "
    static let ID = "id"
    static let UNITS = "units"
    static let MATRIC = "metric"
    static let APPID = "APPID" 
    
    static let DATEFORMAT_dd_MMM_hh_mm_a = "dd MMM hh:mm a"

}


//MARK:- Common API Error constant strings
struct APIErrors {
    static let INVALID_URL:[String:String] = [ConstantStrings.LOCALIZED_ERROR:ConstantStrings.INVALID_URL]
    static let NO_NETWORK:[String:String] = [ConstantStrings.LOCALIZED_ERROR:ConstantStrings.NO_NETWORK]
}

struct ConstantFloats {
    static let periodicFetchDuration:Float = 60 //On each 1 minute
}
