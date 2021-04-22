//
//  SearchCityViewController.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 10/04/21.
//

import UIKit

protocol SearchCityViewControllerDelegate {
    func didSelectedCity(city:City)
}
class SearchCityViewController: UIViewController {
    var delegate:SearchCityViewControllerDelegate?

    @IBOutlet var searchField:UITextField!
    @IBOutlet var tableView:UITableView!
    @IBOutlet weak var titleLabelContainerHeightConstraint: NSLayoutConstraint!
    
    var allCities:[City] = []
    var dataSource:[City] = []
    var cellModels:[SearchCityableViewCellModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCityCellModels()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        if UIDevice.current.orientation.isLandscape {
            titleLabelContainerHeightConstraint.constant = 0
        } else {
            titleLabelContainerHeightConstraint.constant = 50
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
        self.tableView.reloadData()
    } 
    
    func setUpCityCellModels() {
        let searchText = searchField.text ?? ""
        if (searchField.text?.count == 0) {
            dataSource = allCities
        }else {
            dataSource = allCities.filter{$0.name.lowercased().contains(searchText.lowercased()) || $0.country.lowercased().contains(searchText.lowercased())}
        }
        
        cellModels = []
        for _ in dataSource {
            cellModels.append(SearchCityableViewCellModel())
        }
        tableView.reloadData()
    } 
    
    @IBAction func dismissPopUp() {
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func searchFieldEditingChanged(_ sender: UITextField) {
        setUpCityCellModels()
    }
}

extension SearchCityViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = cellModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.identifier) as! SearchCityableViewCell
        cell.city = dataSource[indexPath.row]
        cell.cellModel = cellModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = self.dataSource[indexPath.row]
        citySelected(selectedCity: selectedCity)
    }
    
    func citySelected(selectedCity:City) {
        if (DefaultWrapper().savedCityIds().contains(selectedCity.id)) {
            showSimpleAlert(title: "Alert!", message: "You've already added this city")
        }else {
            DefaultWrapper().addNewCity(cityId: selectedCity.id)
            self.dismiss(animated: true) {
                self.delegate?.didSelectedCity(city: selectedCity)
            }
        }
    }
}

extension SearchCityViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
