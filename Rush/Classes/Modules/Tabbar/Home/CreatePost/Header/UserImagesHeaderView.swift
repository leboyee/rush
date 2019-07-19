//
//  UserImagesHeaderView.swift
//  GotFriends
//
//  Created by iChirag on 09/01/19.
//  Copyright © 2019 Kamal Mittal. All rights reserved.
//

import UIKit


class UserImagesHeaderView: UITableViewHeaderFooterView {
   
    @IBOutlet weak var roundedView: CustomView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var hoverView: UIView!
    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var usernameView: UIView!
    
    var settingButtonEvent: (() -> Void)?
    var addPhotoButtonEvent: (() -> Void)?
    var selectedPhoto: ((_ indexpath: IndexPath) -> Void)?
    var infoButtonEvent: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        roundedView.layer.cornerRadius = 24
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        roundedView.setBackgroundColor()
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
    
    func setup(isHideHoverView: Bool) {
        hoverView.isHidden = isHideHoverView
    }
    
    func setup(isHideUsernameView: Bool) {
        usernameView.isHidden = isHideUsernameView
        if isHideUsernameView == false {
            changePhotoButton.isHidden = true
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
    
    @IBAction func infoButtonAction() {
        infoButtonEvent?()
    }
    
    @IBAction func nameTapButtonAction() {
        infoButtonEvent?()
    }
}
