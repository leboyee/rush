//
//  EventCategoryFilterHeader.swift
//  Rush
//
//  Created by kamal on 11/02/19.
//  Copyright © 2019 Suresh Jagnani. All rights reserved.
//

import UIKit

class EventCategoryFilterHeader: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}

extension EventCategoryFilterHeader {
    func setup(name: String) {
        titleLabel.text = name
    }
}
