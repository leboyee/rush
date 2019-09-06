//
//  TutorialPopUpCell.swift
//  Rush
//
//  Created by ideveloper on 13/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class TutorialPopUpCell: UITableViewCell {

    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    var okButtonClickEvent: ((_ title: String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension TutorialPopUpCell {
    func setup(buttonTitle: String) {
        okButton.setTitle(buttonTitle, for: .normal)
    }
    
    func setup(text: String) {
        titleLabel.text = text
    }
    
    func setup(bgImage: String) {
        bgImageView.image = UIImage(named: bgImage)
    }
}

extension TutorialPopUpCell {
    @IBAction func okButtonAction() {
        okButtonClickEvent?(okButton.titleLabel?.text ?? "")
    }
}
