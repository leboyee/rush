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
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var universtityLabel: UILabel!
    
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

// MARK: - Setup
extension UserImagesHeaderView {
    func setup(image: UIImage?) {
        userImageView.image = image
        
        if image != nil {
            hoverView.isHidden = false
            addPhotoButton.isHidden = true
            changePhotoButton.isHidden = false
        } else {
            hoverView.isHidden = true
            addPhotoButton.isHidden = false
            changePhotoButton.isHidden = true
        }
    }
    
    func setup(isHideHoverView: Bool) {
        hoverView.isHidden = isHideHoverView
    }
    func setup(isHidePhotoButton: Bool) {
        changePhotoButton.isHidden = isHidePhotoButton
    }
    func setup(isHideUsernameView: Bool) {
        usernameView.isHidden = isHideUsernameView
        if isHideUsernameView == false {
            changePhotoButton.isHidden = true
        }
    }
    
    func setup(imageUrl: URL?) {
        userImageView.sd_setImage(with: imageUrl, completed: nil)
        hoverView.isHidden = false
        addPhotoButton.isHidden = true
    }
    
    func setup(userInfo: User?) {
        setup(imageUrl: userInfo?.photo?.url())
        setup(isHideUsernameView: false)
        userNameLabel.text = userInfo?.name
        if let university = userInfo?.university?.first {
            universtityLabel.text = university.universityName
        }
    }
}

// MARK: - Actions

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
