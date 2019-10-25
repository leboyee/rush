//
//  QuestionCell.swift
//  Rush
//
//  Created by Karan kachara on 02/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func set(question: String) {
        questionLabel.text = question
    }
    
    func set(answer: String) {
        answerLabel.text = answer
    }
    
    func set(isSeparatorHide: Bool) {
        separatorView.isHidden = isSeparatorHide
    }
}
