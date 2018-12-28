//
//  CitiesListViewController.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 25/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

import UIKit

public class CitiesListViewController: UITableViewController {
    // MARK: - Private properties
    private let apiManager: CityAPIProvider = APIManager()
    private let repository: CityPersistence = AppRepository.shared
    private var selectedIndex = 0
    
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        
        return view
    }()
    
    // MARK: - Init
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        setupTableView()
        
        fetchInitialData()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Private methods
    private func registerCell() {
        let nib = UINib(nibName: CityCellView.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: CityCellView.identifier)
    }
    
    private func setupTableView() {
        tableView.backgroundView = activityIndicatorView
        tableView.separatorStyle = .none
    }
    
    private func fetchInitialData() {
        activityIndicatorView.startAnimating()
        let initialCityCodes = ["44418", "4118", "804365"]
        var requestCounter = initialCityCodes.count
    
        initialCityCodes.forEach {
            self.apiManager.fetchCity(forCode: $0) { [weak self] in
                guard let self = self else {
                    return
                }
                
                self.repository.addCity(city: $0)
                requestCounter -= 1
                if requestCounter == 0 {
                    self.tableView.reloadData()
                    self.tableView.separatorStyle = .singleLine
                    self.activityIndicatorView.stopAnimating()
                }
            }
        }
    }
    
    // MARK: - Public methods
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushCityDetailsSegue" {
            guard let viewController = segue.destination as? CityDetailsViewController else {
                return
            }
            
            let city = repository.getCities()[selectedIndex]
            viewController.forecastCollection = city.forecastCollection
            viewController.cityName = city.name
        }
        
        if segue.identifier == "PushShowMapSegue" {
            guard let viewController = segue.destination as? ShowMapViewController else {
                return
            }
            
            let city = repository.getCities()[selectedIndex]
            let coordinates = Coordinates(latitude: city.coordinates.latitude,
                                          longitude: city.coordinates.longitude)
            viewController.coordinates = coordinates
        }
    }
}

public extension CitiesListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repository.getCities().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CityCellView.identifier,
            for: indexPath) as? CityCellView else {
                fatalError("Failed to dequeue reusable cell")
        }
        
        let city = repository.getCities()[indexPath.row]
        cell.delegate = self
        
        cell.cityNameLabel.text = city.name
        cell.tempLabel.text = [String(Int(city.brief.currentTemperature)), "°C"].joined(separator: " ")
        cell.iconImageView.image = UIImage(named: AssetCodeMapper.map(city.brief.asset))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "PushCityDetailsSegue", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension CitiesListViewController: CityCellViewDelegate {
    public func cityCellViewDidTapNavigationButton(_ cell: CityCellView) {
        guard let row = tableView.indexPath(for: cell)?.row else {
            return
        }
        
        selectedIndex = row
        performSegue(withIdentifier: "PushShowMapSegue", sender: nil)
    }
}
