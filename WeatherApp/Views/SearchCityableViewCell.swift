//
//  SearchTCityableViewCell.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 10/04/21.
//

import UIKit

class SearchCityableViewCell: UITableViewCell {
    
    @IBOutlet var cityNameLabel:UILabel!
    @IBOutlet var countrySymbolLabel:UILabel!

    var city:City = City([:])
    var cellModel:SearchCityableViewCellModel! {
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
        cityNameLabel.text = cellModel.getCityName(city: city)
        countrySymbolLabel.text = cellModel.getCountryName(city: city)
    }
}
