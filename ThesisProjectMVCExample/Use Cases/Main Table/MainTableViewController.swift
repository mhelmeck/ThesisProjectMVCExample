//
//  MainTableViewController.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 25/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

import UIKit

public class MainTableViewController: UITableViewController {
    // Properties
    private let activityIndicatorView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .gray)
        
        return view
    }()
    
    private var selectedIndex = 0
    private let dataManager = DataManager()
    
    // Setup
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        
        tableView.separatorStyle = .none
        activityIndicatorView.startAnimating()
        var requestCounter = dataManager.cityCodes.count
        self.dataManager.cityCodes.forEach { code in
            self.dataManager.fetchForecast(forCityCode: code) { [weak self] in
                requestCounter -= 1
                if requestCounter == 0 {
                    self?.tableView.reloadData()
                    self?.tableView.separatorStyle = .singleLine
                    self?.activityIndicatorView.stopAnimating()
                }
            }
        }
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tableView.reloadData()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setupTableView() {
        let nib = UINib(nibName: MainTableViewCell.identifier, bundle: nil)
        tableView.backgroundView = activityIndicatorView
        tableView.register(nib, forCellReuseIdentifier: MainTableViewCell.identifier)
    }
    
    // Actions
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PushDetailsSegue" {
            guard let viewController = segue.destination as? DetailViewController else {
                return
            }
            
            let city = dataManager.cityCollection[selectedIndex]
            viewController.viewModel.weatherContainer = city.forecastCollection
            viewController.cityName = city.name
        }
        
        if segue.identifier == "PushAddCitySegue" {
            guard let viewController = segue.destination as? AddCityViewController else {
                return
            }
            
            viewController.dataManager = dataManager
        }
        
        if segue.identifier == "PushMapSegue" {
            guard let viewController = segue.destination as? MapViewController else {
                return
            }
            
            let city = dataManager.cityCollection[selectedIndex]
            viewController.lat = city.coordinates.lat
            viewController.lon = city.coordinates.lon
        }
    }
}

public extension MainTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.cityCollection.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainTableViewCell.identifier,
            for: indexPath) as? MainTableViewCell else {
                fatalError("mkmk")
        }
        
        let city = dataManager.cityCollection[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        
        cell.cityNameLabel.text = city.name
        cell.tempLabel.text = [String(Int(city.brief.currentTemperature)), "°C"].joined(separator: " ")
        cell.iconImageView.image = UIImage(named: AssetCodeMapper.map(city.brief.asset))
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "PushDetailsSegue", sender: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension MainTableViewController: MainTableViewCellDelegate {
    public func mainTableViewCellDidTapNavigationButton(_ cell: MainTableViewCell) {
        selectedIndex = tableView.indexPath(for: cell)?.row ?? 0
        performSegue(withIdentifier: "PushMapSegue", sender: nil)
    }
}
