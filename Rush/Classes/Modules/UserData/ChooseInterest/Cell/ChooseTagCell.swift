//
//  TagCell.swift
//  Rush
//
//  Created by ideveloper on 30/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class ChooseTagCell: UITableViewCell {
    
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var taglistSuperView: UIView!
    @IBOutlet weak var tagListViewHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
extension ChooseTagCell {
    func setup(tagList: [String]) {
        tagListView.removeAllTags()
        tagListView.addTags(tagList)
        tagListView.textFont = UIFont.semibold(sz: 13)
    }
    
    func setupInterest(tagList: [String]) {
        tagListView.removeAllTags()
        tagListView.addTags(tagList)
        tagListView.textFont = UIFont.regular(sz: 17)
        tagListView.tagSelectedBackgroundColor = UIColor.black
        self.layoutIfNeeded()

    }
}

