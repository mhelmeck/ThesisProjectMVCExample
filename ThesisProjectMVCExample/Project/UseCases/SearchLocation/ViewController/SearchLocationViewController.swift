//
//  SearchLocationViewController.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 28/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

import MapKit
import UIKit

public class SearchLocationViewController: UIViewController {
    // MARK: - Private properties
    private let dataManager: DataManagerType = DataManager()
    private let repository: AppRepositoryType = AppRepository.shared
    private let locationManager = CLLocationManager()
    
    private var currentCoordinates: Coordinates?
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        
        return view
    }()
    
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var searchCurrentButton: UIButton!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var currentLocationLabel: UILabel!

    // MARK: - Init
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupCoreLocation()
        setupView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        repository.clearLocations()
        navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Private methods
    @IBAction private func searchButtonTapped(_ sender: Any) {
        guard let query = searchField.text else {
            return
        }
        
        dataManager.fetchLocations(withQuery: query) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.fetchLocations(locations: $0)
        }
    }
    
    @IBAction private func searchCurrentButtonTapped(_ sender: Any) {
        guard let latitude = currentCoordinates?.latitude,
              let longitude = currentCoordinates?.longitude else {
                return
        }
        
        dataManager.fetchLocations(withCoordinate: String(latitude), String(longitude)) { [weak self] in
            guard let self = self else {
                return
            }
            
            self.fetchLocations(locations: $0)
        }
    }
    
    @IBAction private func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupCoreLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    private func setupView() {
        tableView.separatorStyle = .singleLine
        
        setupTextField()
        setupButtons()
    }
    
    private func setupTextField() {
        searchField.delegate = self
        searchField.layer.cornerRadius = 4
        searchField.layer.borderWidth = 2
        searchField.layer.borderColor = UIColor.gray.cgColor
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
    
    private func fetchLocations(locations: [Location]) {
        repository.clearLocations()
        locations.forEach {
            repository.addLocation(location: $0)
        }
        
        tableView.reloadData()
    }
}

extension SearchLocationViewController: UITextFieldDelegate {
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

extension SearchLocationViewController: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repository.getLocations().count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "LocationCell") else {
            fatalError("Failed to dequeue reusable cell")
        }

        let location = repository.getLocations()[indexPath.row]
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.text = location.name

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        prepareViewToClose()
        let location = repository.getLocations()[indexPath.row]
        let cityCode = String(location.code)

        dataManager.fetchCity(forCode: cityCode) { [weak self] in
            self?.repository.addCity(city: $0)
            
            self?.repository.clearLocations()
            self?.activityIndicatorView.stopAnimating()
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func prepareViewToClose() {
        view.addSubview(activityIndicatorView)
        activityIndicatorView.center = view.center
        activityIndicatorView.backgroundColor = UIColor.white
        
        activityIndicatorView.startAnimating()
        tableView.isHidden = true
        
        searchField.resignFirstResponder()
    }
}

extension SearchLocationViewController: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let currentLocation = locations.last else {
            return
        }
        
        let latitude = currentLocation.coordinate.latitude
        let longitude = currentLocation.coordinate.longitude
        
        dataManager.fetchLocations(withCoordinate: String(latitude), String(longitude)) { [weak self] in
            guard let currentLocation = $0.first else {
                return
            }
            
            self?.currentCoordinates = currentLocation.coordinates
            self?.currentLocationLabel.text = "Your current location is: \(currentLocation.name)"
            self?.searchCurrentButton.isEnabled = true
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location with error: \(error)")
    }
}
