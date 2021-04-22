//
//  HomeViewController.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 09/04/21.
//

import UIKit

class HomeViewController: UITableViewController {

    @IBOutlet var noNetworkHeaderSpace:UIView! //Since it is a single network call app, I've used this. Else, we can add a common view to UIWindow
    @IBOutlet var networkMessageLabel:UILabel!
    
    //MARK:- Variables
    var savedCityIds:[String] = []
    var cellModels:[HomeViewTableCellModel] = []
    var periodicFetchDuration:Float = ConstantFloats.periodicFetchDuration //On each 1 minute
    var responseCache:[String:Weather] = [:]
    var allCities:[City] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        allCities = getCities()
        setUpCityCellModels()
        updateWeatherPeriodically()
        configureRefreshControl()
        noNetworkHeaderSpace.isHidden = true
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator) 
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 
        return cellModels.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = cellModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.identifier, for: indexPath) as! HomeViewTableCell
        cell.allCities = allCities
        cell.responseCache = responseCache
        cell.cityId = savedCityIds[indexPath.row]
        cell.cellModel = cellModel
        cell.delegate = self
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let savedCityIds = DefaultWrapper().savedCityIds()
            if (savedCityIds.count > indexPath.row) {
                DefaultWrapper().removeNewCity(cityId: savedCityIds[indexPath.row])
                setUpCityCellModels()
            } 
        } 
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedWeather = responseCache[savedCityIds[indexPath.row]] {
            goToDetailPage(selectedWeather: selectedWeather)
        }
    }
    
    func goToDetailPage(selectedWeather:Weather) {
        performSegue(withIdentifier: "DetailViewController", sender: selectedWeather)
    }
     
    //MARK:-
    func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action:#selector(handleRefreshControl), for: .valueChanged)
    }
    
    @objc func handleRefreshControl() {
        DispatchQueue.main.async {
            self.responseCache = [:]
            self.setUpCityCellModels()
            self.tableView.refreshControl?.endRefreshing()
        }
    }
}

extension HomeViewController {
    func updateWeatherPeriodically() {
        responseCache = [:]
        Timer.scheduledTimer(withTimeInterval: TimeInterval(periodicFetchDuration), repeats: true) { (_) in
            self.tableView.reloadData()
        }
    }
    
    //MARK:- UI Updates
    func setUpCityCellModels() {
        cellModels = []
        savedCityIds = DefaultWrapper().savedCityIds()
        for _ in savedCityIds {
            cellModels.append(HomeViewTableCellModel())
        }
        DispatchQueue.main.async {
            self.activityStopAnimating()
            self.tableView.reloadData()
        }
    }
}

extension HomeViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? SearchCityViewController {
            vc.delegate = self
            vc.allCities = allCities
        }else if let vc = segue.destination as? DetailViewController, let selectedWeather = sender as? Weather {
            vc.selectedWeather = selectedWeather
        }
    }
}

extension HomeViewController: SearchCityViewControllerDelegate {
    func didSelectedCity(city: City) {
        setUpCityCellModels()
    }
}

extension HomeViewController: HomeTableViewCellDelegate {
    func shouldUpdateCache(weather: Weather) {
        responseCache[weather.id] = weather
    }
    func didUpdateNetworkStatusUI(status: Bool, message: String) {
        DispatchQueue.main.async {
            self.networkMessageLabel.text = message
            self.noNetworkHeaderSpace.isHidden = status
        }
    }
    
}
