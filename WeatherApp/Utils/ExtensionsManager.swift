//
//  ExtensionsManager.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 09/04/21.
//

import UIKit

extension NSObject {
    func getCities() ->[City] {
        if let filepath = Bundle.main.path(forResource: "Cities", ofType: "json") {
            do {
                let contents = try String(contentsOfFile: filepath) 
                var cities:[City] = []
                for city in contents.toArray() {
                    cities.append(City(city))
                }
                return cities
            } catch {
                //Error loading Cities.json
            }
        } else {
            // Cities.json not found
        }
        return []
    }
}

extension String {
    //MARK:- To convert JSON String to array
    func toArray() -> [[String: Any]] {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] ?? []
            } catch {
                //Error in convertion
            }
        }
        return []
    }
    
    func getDateStringFromUnixTimeStamp(format:String) -> String {
        if let timeStamp = Double(self) {
            let date = Date(timeIntervalSince1970: timeStamp)
            let formatter = DateFormatter()
            formatter.dateFormat = format
            let dateString = formatter.string(from: date)
            return dateString
        }
        return ""
    }
}

extension Dictionary where Key == String {
    //MARK:- Used to avoid exceptions and used to set default value
    func getIntAsString(key:String)->String {
        if let objectValue = self[key] as? Int  {
            return "\(objectValue)"
        }else if let objectValue = self[key] as? String  {
            return objectValue
        } 
        return ""
    }
    
    func getDouble(key:String)->Double {
        if let objectValue = self[key] as? Int  {
            return Double(objectValue)
        }else if let objectValue = self[key] as? String  {
            return Double(objectValue) ?? 0.0
        }else if let objectValue = self[key] as? Float  {
            return Double(objectValue)
        }else if let objectValue = self[key] as? Double  {
            return objectValue
        }
        return 0.0
    }
    
    func getFloatAsString(key:String)->String {
        if let objectValue = self[key] as? Int  {
            return "\(objectValue)"
        }else if let objectValue = self[key] as? String  {
            return objectValue
        }else if let objectValue = self[key] as? Float  {
            return "\(objectValue)"
        }else if let objectValue = self[key] as? Double  {
            return "\(objectValue)"
        }
        return ""
    }
}

extension Double {
    func roundedToString(toPlaces places:Int) -> String {
        let divisor = pow(10.0, Double(places))
        let value =  "\((self * divisor).rounded() / divisor)"
        if (places == 0) {
            return value.components(separatedBy: ".").first ?? value
        }
        return value
    }
}

extension UIViewController {
    func showSimpleAlert(title:String, message:String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //
    func activityStartAnimating(activityColor: UIColor, backgroundColor: UIColor) {
        let backgroundView = UIView()
        backgroundView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        backgroundView.backgroundColor = backgroundColor
        backgroundView.tag = 475647
        
        var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
        activityIndicator = UIActivityIndicatorView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium
        activityIndicator.color = activityColor
        activityIndicator.startAnimating()
        self.view.isUserInteractionEnabled = false
        
        backgroundView.addSubview(activityIndicator)
        self.view.addSubview(backgroundView)
    }
    
    func activityStopAnimating() {
        if let background = view.viewWithTag(475647){
            background.removeFromSuperview()
        }
        self.view.isUserInteractionEnabled = true
    }
}
