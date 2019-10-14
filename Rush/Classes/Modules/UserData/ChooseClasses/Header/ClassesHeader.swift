//
//  ClassesHeader.swift
//  Rush
//
//  Created by ideveloper on 06/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class ClassesHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var detailsLabel: CustomLabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var headerButton: UIButton!
    @IBOutlet weak var titleLabelHightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        detailsLabel.isHidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

// MARK: - Other functions
extension ClassesHeader {
    func setup(title: String) {
        titleLabel.text = title
    }
    
    func setup(detailsLableText: String) {
        titleLabelHightConstraint.constant = detailsLableText.isNotEmpty ? 24 : 47
        detailsLabel.isHidden = false
        detailsLabel.text = detailsLableText
        titleLabel.font = UIFont.semibold(sz: 14)
    }
}
