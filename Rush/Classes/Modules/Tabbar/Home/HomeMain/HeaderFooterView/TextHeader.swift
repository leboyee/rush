//
//  TextHeader.swift
//  PaidMeals
//
//  Created by kamal on 11/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//

import UIKit

class TextHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    var detailButtonClickEvent: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        detailButton.setImage(UIImage(named: isDarkModeOn ? "white-arrow" : "red-arrow"), for: .normal)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}

// MARK: - Actions
extension TextHeader {
    @IBAction func replaceButtonAction(_ sender: Any) {
        detailButtonClickEvent?()
    }
}

extension TextHeader {
    func setup(title: String) {
        titleLabel.text = title
    }
    
    func setup(isDetailArrowHide: Bool) {
        detailButton.isHidden = isDetailArrowHide
    }
    
    func setup(detailArrowImage: UIImage) {
        detailButton.setImage( detailArrowImage, for: .normal)
    }
    
    func setup(textColor: UIColor) {
        titleLabel.textColor = textColor
    }
}
