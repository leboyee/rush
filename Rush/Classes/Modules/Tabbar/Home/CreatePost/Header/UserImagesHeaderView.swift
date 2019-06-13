//
//  UserImagesHeaderView.swift
//  GotFriends
//
//  Created by iChirag on 09/01/19.
//  Copyright © 2019 Kamal Mittal. All rights reserved.
//

import UIKit


class UserImagesHeaderView: UITableViewHeaderFooterView {
   
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var hoverView: UIView!
    @IBOutlet weak var changePhotoButton: UIButton!
    
    
    var settingButtonEvent: (() -> Void)?
    var addPhotoButtonEvent: (() -> Void)?
    var selectedPhoto: ((_ indexpath: IndexPath) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        roundedView.layer.cornerRadius = 24
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}

//MARK: - Setup
extension UserImagesHeaderView {
    func setup(image: UIImage?) {
        userImageView.image = image
        
        if image != nil {
            hoverView.isHidden = false
            addPhotoButton.isHidden = true
        } else {
            hoverView.isHidden = true
            addPhotoButton.isHidden = false
        }
    }
}

//MARK: - Actions

extension UserImagesHeaderView {
    
    @IBAction func changePhotoButtonAction(_ sender: Any) {
        addPhotoButtonEvent?()
    }
    
    @IBAction func addPhotoButtonAction(_ sender: Any) {
        addPhotoButtonEvent?()
    }
}
