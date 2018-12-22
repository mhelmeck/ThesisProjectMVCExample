//
//  AddCityViewController.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 28/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

import MapKit
import UIKit

public class AddCityViewController: UIViewController {
    // Properties
    public let locationManager = CLLocationManager()
    public var dataManager: DataManager!
    
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var searchCurrentButton: UIButton!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var currentLocationLabel: UILabel!
    
    private var activityIndicatorView: UIActivityIndicatorView!
    private var currentLocation: CLLocation? {
        didSet {
            searchCurrentButton.isEnabled = true
        }
    }
    
    // Init
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
        searchField.delegate = self
        
        setupCoreLocation()
        setupView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        dataManager.locationCollection.removeAll()
        navigationController?.isNavigationBarHidden = true
    }
    
    // Actions
    @IBAction private func searchButtonTapped(_ sender: Any) {
        guard let query = searchField.text else {
            return
        }
        
        dataManager.fetchLocations(withQuery: query) {
            self.tableView.reloadData()
        }
    }
    
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func searchCurrentButtonTapped(_ sender: Any) {
        guard let location = currentLocation else {
            return
        }
        
        let lat = String(location.coordinate.latitude)
        let lon = String(location.coordinate.longitude)
        
        dataManager.fetchLocations(withLatLon: lat, lon) {
            self.tableView.reloadData()
        }
    }
    
    // Private methods
    private func setupView() {
        tableView.separatorStyle = .singleLine
        searchField.layer.cornerRadius = 4
        searchField.layer.borderWidth = 2
        searchField.layer.borderColor = UIColor.gray.cgColor
        
        setupButtons()
    }
    
    private func setupCoreLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    private func setupButtons() {
        [cancelButton, searchButton, searchCurrentButton].forEach {
            $0?.setTitleColor(.white, for: .normal)
            $0?.backgroundColor = .customBlue
            $0?.layer.cornerRadius = 4.0
        }
        cancelButton.setTitle("Cancel", for: .normal)
        searchButton.setTitle("Search", for: .normal)
        searchCurrentButton.setTitle("Current", for: .normal)
        
        searchCurrentButton.setBackground(color: .gray, forState: .disabled)
        searchCurrentButton.isEnabled = false
    }
}

extension AddCityViewController: UITextFieldDelegate {
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        searchField.layer.borderColor = UIColor.customBlue.cgColor
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        searchField.layer.borderColor = UIColor.gray.cgColor
    }
}

extension AddCityViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.locationCollection.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddCityCell") else {
            fatalError("Error")
        }
        
        let location = dataManager.locationCollection[indexPath.row]
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = location.name
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let location = dataManager.locationCollection[indexPath.row]
        let cityCode = String(location.code)
        
        activityIndicatorView.center = view.center
        view.addSubview(activityIndicatorView)
        activityIndicatorView.backgroundColor = UIColor.white
        activityIndicatorView.startAnimating()
        
        tableView.isHidden = true
        searchField.resignFirstResponder()
        
        dataManager.fetchForecast(forCityCode: cityCode) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
            self?.dataManager.locationCollection.removeAll()
            self?.activityIndicatorView.stopAnimating()
        }
    }
}

extension AddCityViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let currentLocation = locations.last else {
            return
        }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        dataManager.fetchLocation(withLatLon: String(lat), String(lon)) { [weak self] locations in
            guard let current = locations.first else {
                return
            }
            
            self?.currentLocation = currentLocation
            self?.currentLocationLabel.text = "Your current location is: \(current.name)"
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}
