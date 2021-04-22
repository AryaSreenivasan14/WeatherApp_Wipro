//
//  WeatherAppTests.swift
//  WeatherAppTests
//
//  Created by Arya Sreenivasan on 09/04/21.
//

import XCTest
@testable import WeatherApp

class WeatherAppTests: XCTestCase {

    var homeVC: HomeViewController?
    var detailVC: DetailViewController?
    var searchVC: SearchCityViewController?
    var urlSession: URLSession!


    override func setUpWithError() throws {
        urlSession = URLSession(configuration: .default)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        self.homeVC = (storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController)
        self.homeVC?.loadView()
        self.homeVC?.viewDidLoad()
        
        self.detailVC = (storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController)
        self.detailVC?.loadView()
        self.detailVC?.viewDidLoad()

        self.searchVC = (storyboard.instantiateViewController(withIdentifier: "SearchCityViewController") as! SearchCityViewController)
        self.searchVC?.loadView()
        self.searchVC?.viewDidLoad()

    }
    
    override func tearDownWithError() throws {
        urlSession = nil
        try super.tearDownWithError()
    }

    //MARK:- HomeViewController Tests
    func testHomeHasATableView() {
        XCTAssertNotNil(homeVC?.tableView)
    }
    
    
    //MARK:- SearchCityViewController Tests
    func testSearchVCHasATableView() {
        XCTAssertNotNil(searchVC?.tableView)
    }
    
    func testRandomAddCity() {
        let allCities = (self.homeVC?.allCities ?? [])
        // Thread.sleep(forTimeInterval: 5)
        let randomCity = allCities[Int(arc4random())%(allCities.count - 1)]
        //print("randomCity ====> \(randomCity.name)")
        self.searchVC?.citySelected(selectedCity: randomCity)
    }
    
   
    func testDetailHasATableView() {
        XCTAssertNotNil(detailVC?.tableView)
    }
    
    //MARK:- DetailViewController Tests
    func testDetailVCHasATableView() {
        XCTAssertNotNil(detailVC?.tableView)
        XCTAssertNotNil(homeVC?.tableView)
        
        let allCities = (self.homeVC?.allCities ?? [])
        //Thread.sleep(forTimeInterval: 5)
        let randomCity = allCities[Int(arc4random())%(allCities.count - 1)]
        self.searchVC?.citySelected(selectedCity: randomCity)
        //Thread.sleep(forTimeInterval: 10)
        
        if let cityId = homeVC?.responseCache[randomCity.id] {
            homeVC?.goToDetailPage(selectedWeather:cityId)
        }
    }
    
    //MARK:- API Test case with expectation
    func testAPICallGetsHTTPStatusCode200() throws {
        let allCities = (self.homeVC?.allCities ?? [])
        Thread.sleep(forTimeInterval: 5) //Since it is synchronous
        let randomCity = allCities[Int(arc4random())%(allCities.count - 1)]

        if let cityId = homeVC?.responseCache[randomCity.id] {
            let urlString = API.ROOT+"\(ConstantStrings.ID)=\(cityId)&\(ConstantStrings.UNITS)=\(ConstantStrings.MATRIC)&\(ConstantStrings.APPID)="+API.KEY
            let url = URL(string: urlString)!
            let promise = expectation(description: "Status code: 200") //For asynchronous
            
            let dataTask = urlSession.dataTask(with: url) { _, response, error in
                if let error = error {
                    XCTFail("Error: \(error.localizedDescription)")
                    return
                } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                    if statusCode == 200 {
                        promise.fulfill()
                    } else {
                        XCTFail("Status code: \(statusCode)")
                    }
                }
            }
            dataTask.resume()
            wait(for: [promise], timeout: 5)
        }
    }
     
}
