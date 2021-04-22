//
//  ApiManager.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 09/04/21.
//

import UIKit

//MARK:- API constants
struct API {
    static let KEY = "ea9d58e4292acee6465b12cd3a1c87bd"
    static let ROOT = "http://api.openweathermap.org/data/2.5/weather?" //For single
    
    static let ICON_ROOT = "http://openweathermap.org/img/wn/ICON_PLACEHOLDER@2x.png"
}

class ApiManager: NSObject {
    //MARK:-
    func fetchWeatherDetails(cityId:String, completion: @escaping ([String: Any], _ error:Error?) -> ()) {
         
        let urlString = API.ROOT+"\(ConstantStrings.ID)=\(cityId)&\(ConstantStrings.UNITS)=\(ConstantStrings.MATRIC)&\(ConstantStrings.APPID)="+API.KEY
        guard let url = URL(string: urlString) else {
            let invalidURLError = NSError(domain: API.ROOT, code: 404, userInfo: APIErrors.INVALID_URL)
            completion([:],invalidURLError)
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if let error = error as NSError?, error.domain == NSURLErrorDomain, error.code == NSURLErrorNotConnectedToInternet {
                let networkError = NSError(domain: API.ROOT, code: error.code, userInfo: APIErrors.NO_NETWORK)
                completion([:],networkError)
            }
            
            if (error != nil) {
                completion([:],error)
            } else {
                do {
                    if  let jsonDict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
                        completion(jsonDict,nil)
                    }else {
                        completion([:],nil)
                    }
                } catch let parsingError {
                    completion([:],parsingError)
                }
            }
        })
        dataTask.resume()
    }
}
