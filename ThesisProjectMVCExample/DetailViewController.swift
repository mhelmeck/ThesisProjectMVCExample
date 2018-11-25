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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func previewButtonTapped(_ sender: Any) {

    }
    
    @IBAction private func nextButtonTapped(_ sender: Any) {
        
    }
}
