//
//  ViewController.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 18/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

import UIKit

public class DetailViewController: UIViewController {
    // Properties
    public var cityName: String = ""
    public var forecast: Forecast!
    
    @IBOutlet private weak var dateLabel: UILabel!
    
    @IBOutlet private weak var mainViewContainer: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var typeTitle: UILabel!
    @IBOutlet private weak var typeValue: UILabel!
    
    @IBOutlet private weak var minTempTitle: UILabel!
    @IBOutlet private weak var minTempValue: UILabel!
    
    @IBOutlet private weak var maxTempValue: UILabel!
    @IBOutlet private weak var maxTempTitle: UILabel!
    
    @IBOutlet private weak var windSpeedTitle: UILabel!
    @IBOutlet private weak var windSpeedValue: UILabel!
    
    @IBOutlet private weak var windDirectionTitle: UILabel!
    @IBOutlet private weak var windDirectionValue: UILabel!
    
    @IBOutlet private weak var rainfallTitle: UILabel!
    @IBOutlet private weak var rainfallValue: UILabel!
    
    @IBOutlet private weak var pressureTitle: UILabel!
    @IBOutlet private weak var pressureValue: UILabel!
    
    @IBOutlet private weak var previewButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    
    // Life cycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        super.title = cityName
        
        setupView()
        updateView(withForecast: forecast)
    }
    
    // Actions
    @IBAction private func previewButtonTapped(_ sender: Any) {

    }
    
    @IBAction private func nextButtonTapped(_ sender: Any) {
        
    }
    
    // Private methods
    private func setupView() {
        view.backgroundColor = .white
        
        [typeTitle,
         minTempTitle,
         maxTempTitle,
         windSpeedTitle,
         windDirectionTitle,
         rainfallTitle,
         pressureTitle].forEach {
            $0?.textColor = .gray
        }
        
        [typeValue,
         minTempValue,
         maxTempValue,
         windSpeedValue,
         windDirectionValue,
         rainfallValue,
         pressureValue].forEach {
            $0?.text = ""
            $0?.textColor = .customPurple
        }
        
        dateLabel.text = "".uppercased()
        typeTitle.text = "Type: ".uppercased()
        minTempTitle.text = "Min temperature: ".uppercased()
        maxTempTitle.text = "Max temperature: ".uppercased()
        windSpeedTitle.text = "Wind speed: ".uppercased()
        windDirectionTitle.text = "Wind direction: ".uppercased()
        rainfallTitle.text = "Rainfall: ".uppercased()
        pressureTitle.text = "Pressure: ".uppercased()
        
        imageView.contentMode = .scaleAspectFit
        
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
            imageView.image = image
        }
        
        dateLabel.text = forecast.date
        typeValue.text = forecast.type
        maxTempValue.text = [String(Int(forecast.maxTemperature)), "°C"].joined(separator: " ")
        minTempValue.text = [String(Int(forecast.minTemperature)), "°C"].joined(separator: " ")
        windSpeedValue.text = [String(Int(forecast.windSpeed)), "m/s"].joined(separator: " ")
        windDirectionValue.text = forecast.windDirection
        pressureValue.text = [String(Int(forecast.airPressure)), "hPa"].joined(separator: " ")
        
        switch forecast.assetCode {
        case "h", "hr", "lr", "s", "t":
            rainfallValue.text = "It's raining"
        default:
            rainfallValue.text = "It's not raining"
        }
    }
    
    private func handleButton(withType type: ButtonType, isEnabled: Bool) {
        switch type {
        case .next:
            nextButton.isEnabled = isEnabled
        case .preview:
            previewButton.isEnabled = isEnabled
        }
    }
}
