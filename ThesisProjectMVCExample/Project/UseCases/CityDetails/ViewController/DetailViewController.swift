//
//  CityDetailsViewController.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 18/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

import UIKit

public class CityDetailsViewController: UIViewController {
    // MARK: - Public properties
    public var forecastCollection = [Forecast]()
    public var cityName: String = ""
    
    // MARK: - Private properties
    @IBOutlet private weak var forecastView: ForecastUIView!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var previewButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    private var forecastIndex: Int = 0 {
        didSet {
            handleButtons(at: forecastIndex)
            updateView(withForecast: forecastCollection[forecastIndex])
            dateLabel.text = forecastCollection[forecastIndex].date
        }
    }
    
    // MARK: - Init
    override public func viewDidLoad() {
        super.viewDidLoad()
        super.title = cityName
        
        setupView()
        updateView(withForecast: forecastCollection.first!)
        
        forecastIndex = 0
    }
    
    // MARK: - Private methods
    @IBAction private func previewButtonTapped(_ sender: Any) {
        perform(animation: {
            self.forecastView.alpha = 0
        }, withCompletion: {
            self.forecastIndex -= 1
        })
        
        perform(animation: {
            self.forecastView.alpha = 1
        }, withCompletion: nil)
    }
    
    @IBAction private func nextButtonTapped(_ sender: Any) {
        perform(animation: {
            self.forecastView.alpha = 0
        }, withCompletion: {
            self.forecastIndex += 1
        })
        
        perform(animation: {
            self.forecastView.alpha = 1
        }, withCompletion: nil)
    }
    
    private func setupView() {
        dateLabel.text = "".uppercased()

        previewButton.setTitle("Preview", for: .normal)
        nextButton.setTitle("Next", for: .normal)
        
        [previewButton, nextButton].forEach {
            $0?.setTitleColor(.white, for: .normal)
            
            $0?.backgroundColor = .customBlue
            $0?.setBackground(color: .gray, forState: .disabled)
            $0?.layer.cornerRadius = 4.0
            
            $0?.isEnabled = false
        }
    }
    
    private func updateView(withForecast forecast: Forecast) {
        if let image = UIImage(named: AssetCodeMapper.map(forecast.assetCode)) {
            forecastView.imageView.image = image
        }
        
        dateLabel.text = forecast.date
        forecastView.typeValue.text = forecast.type
        forecastView.maxTempValue.text = [String(Int(forecast.maxTemperature)), "°C"].joined(separator: " ")
        forecastView.minTempValue.text = [String(Int(forecast.minTemperature)), "°C"].joined(separator: " ")
        forecastView.windSpeedValue.text = [String(Int(forecast.windSpeed)), "m/s"].joined(separator: " ")
        forecastView.windDirectionValue.text = forecast.windDirection
        forecastView.pressureValue.text = [String(Int(forecast.airPressure)), "hPa"].joined(separator: " ")
        
        switch forecast.assetCode {
        case "h", "hr", "lr", "s", "t":
            forecastView.rainfallValue.text = "It's raining"
        default:
            forecastView.rainfallValue.text = "It's not raining"
        }
    }
    
    private func handleButtons(at forecastIndex: Int) {
        if forecastIndex == 0 {
            previewButton.isEnabled = false
            if forecastIndex != forecastCollection.count - 1 {
                nextButton.isEnabled = true
            }
        }
        
        if forecastIndex == forecastCollection.count - 1 {
            nextButton.isEnabled = false
            if forecastIndex != 0 {
                previewButton.isEnabled = true
            }
        }
        
        if forecastIndex > 0 && forecastIndex < forecastCollection.count - 1 {
            previewButton.isEnabled = true
            nextButton.isEnabled = true
        }
    }
    
    private func perform(animation: @escaping () -> Void,
                         withCompletion completion: (() -> Void)?) {
        UIView.animate(
            withDuration: 0.75,
            delay: 0.0,
            options: .curveEaseOut,
            animations: { animation() },
            completion: { _ in completion?() }
        )
    }
}
