//
//  MainTableViewCell.swift
//  ThesisProjectMVCExample
//
//  Created by Maciej Hełmecki on 25/11/2018.
//  Copyright © 2018 Maciej Hełmecki. All rights reserved.
//

import UIKit

public protocol MainTableViewCellDelegate: class {
    func mainTableViewCellDidTapNavigationButton(_ cell: MainTableViewCell)
}

public class MainTableViewCell: UITableViewCell {
    // MARK: - Private properties
    //swiftlint:disable private_outlet
    @IBOutlet public weak var cityNameLabel: UILabel!
    @IBOutlet public weak var tempLabel: UILabel!
    @IBOutlet public weak var iconImageView: UIImageView!
    
    weak public var delegate: MainTableViewCellDelegate?
    
    // MARK: - Init
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Public methods
    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction public func navigationButtonTapped(_ sender: Any) {
        delegate?.mainTableViewCellDidTapNavigationButton(self)
    }
}
