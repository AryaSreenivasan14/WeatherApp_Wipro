//
//  DetailTableViewCell.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 10/04/21.
//

import UIKit

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var mainTempLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    
    var weather:Weather = Weather([:])
    var cellModel:DetailTableViewCellModel! {
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
    
    func configureCell() {
        cityNameLabel.text = cellModel.getCityName(weather: weather)
        mainTempLabel.text = cellModel.getMinTemperature(weather: weather)
        minTemperatureLabel.text = cellModel.getMaxTemperature(weather: weather)
        weatherConditionLabel.text = cellModel.getCurrentWeatherCondition(weather: weather)
        humidityLabel.text = cellModel.getHumidity(weather: weather)
        
        ImageManager().setImageFrom(urlString: cellModel.getWeatherIconUrlString(weather: weather)) { (image) in
            DispatchQueue.main.async {
                self.weatherIcon.image = image
            }
        }
    }
}
