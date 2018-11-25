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
    private var activityIndicatorView: UIActivityIndicatorView!
    private var selectedIndex = 0
    private let dataManager = DataManager()
    
    // Setup
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicatorView = UIActivityIndicatorView(style: .gray)
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
            
            let selectedCityWeather = dataManager.forecast[selectedIndex]
            viewController.weather = selectedCityWeather.weather.first!
            viewController.cityName = selectedCityWeather.cityName
        }
    }
}

public extension MainTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.forecast.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MainTableViewCell.identifier,
            for: indexPath) as? MainTableViewCell else {
                fatalError("mkmk")
        }
        
        let cityWeather = dataManager.forecast[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        
        cell.cityNameLabel.text = cityWeather.cityName
        cell.tempLabel.text = [String(Int(cityWeather.temperature)), "°C"].joined(separator: " ")
        cell.iconImageView.image = UIImage(named: AssetCodeMapper.map(cityWeather.assetType))
        
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
//        selectedIndex = tableView.indexPath(for: cell)?.row ?? 0
//        performSegue(withIdentifier: "PushMapSegue", sender: nil)
    }
}
