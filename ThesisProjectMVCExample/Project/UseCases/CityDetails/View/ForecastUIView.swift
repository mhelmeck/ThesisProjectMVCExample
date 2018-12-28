//
//  ForecastUIView.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 23/12/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

import UIKit

public class ForecastUIView: UIView {
    // MARK: - Public properties
    //swiftlint:disable private_outlet
    @IBOutlet public weak var imageView: UIImageView!
    
    @IBOutlet public weak var typeTitle: UILabel!
    @IBOutlet public weak var typeValue: UILabel!
    
    @IBOutlet public weak var minTempTitle: UILabel!
    @IBOutlet public weak var minTempValue: UILabel!
    
    @IBOutlet public weak var maxTempTitle: UILabel!
    @IBOutlet public weak var maxTempValue: UILabel!
    
    @IBOutlet public weak var windSpeedTitle: UILabel!
    @IBOutlet public weak var windSpeedValue: UILabel!
    
    @IBOutlet public weak var windDirectionTitle: UILabel!
    @IBOutlet public weak var windDirectionValue: UILabel!
    
    @IBOutlet public weak var rainfallTitle: UILabel!
    @IBOutlet public weak var rainfallValue: UILabel!
    
    @IBOutlet public weak var pressureTitle: UILabel!
    @IBOutlet public weak var pressureValue: UILabel!
    
    // MARK: - Init
    override public func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Private methods
    private func setupView() {
        imageView.contentMode = .scaleAspectFit
        
        setupLabels()
    }
    
    private func setupLabels() {
        backgroundColor = .white
        
        [typeTitle,
         minTempTitle,
         maxTempTitle,
         windSpeedTitle,
         windDirectionTitle,
         rainfallTitle,
         pressureTitle].forEach {
            $0?.textColor = .gray
        }
        
        typeTitle.text = "Type: ".uppercased()
        minTempTitle.text = "Min temperature: ".uppercased()
        maxTempTitle.text = "Max temperature: ".uppercased()
        windSpeedTitle.text = "Wind speed: ".uppercased()
        windDirectionTitle.text = "Wind direction: ".uppercased()
        rainfallTitle.text = "Rainfall: ".uppercased()
        pressureTitle.text = "Pressure: ".uppercased()
        
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
    }
}
