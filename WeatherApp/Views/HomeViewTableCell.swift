//
//  HomeViewTableCell.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 09/04/21.
//

import UIKit

protocol HomeTableViewCellDelegate {
    func shouldUpdateCache(weather:Weather)
    func didUpdateNetworkStatusUI(status:Bool, message:String)
}

class HomeViewTableCell: UITableViewCell {
    var delegate:HomeTableViewCellDelegate?

    @IBOutlet var cityNameLabel:UILabel!
    @IBOutlet var countryAndTimeLabel:UILabel!
    @IBOutlet var temperatureLabel:UILabel!
    @IBOutlet var weatherIcon:UIImageView!
    @IBOutlet var activityIndicator:UIActivityIndicatorView!

    var allCities:[City] = []
    var responseCache:[String:Weather] = [:]
    var cityId:String = ""
    var cellModel:HomeViewTableCellModel! {
        didSet {
            configureCell()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated) 
    }
    
    func clearAllLabels() {
        cityNameLabel.text = ""
        countryAndTimeLabel.text = ""
        temperatureLabel.text = ""
    }

    func configureCell() {
        clearAllLabels()
        cityNameLabel.text = cellModel.getCityName(allCities: allCities, cityId: cityId)
        countryAndTimeLabel.text = cellModel.getCountryName(allCities: allCities, cityId: cityId)
        
        activityIndicator.startAnimating()
        cellModel.getDataFromServer(cityId: cityId, responseCache: responseCache, completion: { (weatherResponse, error) in
             
            if let error = error {
                self.delegate?.didUpdateNetworkStatusUI(status: false, message: error.localizedDescription)
                return
            }
            self.delegate?.didUpdateNetworkStatusUI(status: true, message: ConstantStrings.EMPTY)

            DispatchQueue.main.async {
                self.countryAndTimeLabel.text = self.cellModel.getCountryAndTimeName(weather: weatherResponse)
                self.temperatureLabel.text = self.cellModel.getTemperature(weather: weatherResponse)
                
                ImageManager().setImageFrom(urlString: self.cellModel.getWeatherIconUrlString(weather: weatherResponse)) { (image) in
                    DispatchQueue.main.async {
                        self.weatherIcon.image = image
                    }
                }
                self.activityIndicator.stopAnimating()
                self.delegate?.shouldUpdateCache(weather: weatherResponse)
            }
        })
    }
    
}
