//
//  TagCell.swift
//  Rush
//
//  Created by ideveloper on 30/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class TagCell: UITableViewCell {
    
    @IBOutlet weak var tagListView: TagListView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
extension TagCell {
    func setup(tagList: [String]) {
        tagListView.removeAllTags()
        tagListView.addTags(tagList)
        tagListView.textFont = UIFont.semibold(sz: 13)
        self.layoutIfNeeded()
    }
    
    func setupInterest(tagList: [String]) {
        tagListView.removeAllTags()
        tagListView.addTags(tagList)
        tagListView.textFont = UIFont.regular(sz: 17)
    }
    
    func set(interest: [Interest]) {
        
    }
}

extension TagCell: TagListViewDelegate {
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }

}
