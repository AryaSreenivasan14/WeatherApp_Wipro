//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Arya Sreenivasan on 10/04/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var tableView:UITableView!

    var cellModels:[DetailTableViewCellModel] = []
    var selectedWeather:Weather = Weather([:]) {
        didSet {
            setUpCityCellModels()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        self.tableView.reloadData()
    }
    
    //MARK:- UI Updates
    func setUpCityCellModels() {
        cellModels = [DetailTableViewCellModel()]
        DispatchQueue.main.async {
            self.activityStopAnimating()
            self.tableView.reloadData()
        }
    }
    
}

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellModel = cellModels[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellModel.identifier) as! DetailTableViewCell
        cell.weather = selectedWeather
        cell.cellModel = cellModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellModel = cellModels[indexPath.row]
        return cellModel.getCellHeight(tableView: tableView)
    }
    
}

extension DetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BgAnimationViewController {
            vc.selectedWeather = selectedWeather
        }
    }
}
