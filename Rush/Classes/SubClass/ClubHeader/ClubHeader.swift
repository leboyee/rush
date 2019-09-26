//
//  ClubHeader.swift
//  Rush
//
//  Created by kamal on 14/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import SDWebImage

protocol ClubHeaderDelegate: class {
    func addPhotoOfClub()
    func infoOfClub()
}

class ClubHeader: UIView {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var addPhotoButton: UIButton!
    @IBOutlet weak var hoverView: UIView!
    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    weak var delegate: ClubHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}

extension ClubHeader {
    
    private func commonInit() {
        let nib  = UINib(nibName: String(describing: ClubHeader.self), bundle: nil)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.clipsToBounds = true
            addSubview(view)
            addViewConstraint(view: view)
        }
    }
    
    private func addViewConstraint(view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        let top = view.topAnchor.constraint(equalTo: self.topAnchor)
        let bottom = view.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let leading = view.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        let trailing = view.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        addConstraints([top, bottom, trailing, leading])
    }
}

// MARK: - Other
extension ClubHeader {
    
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
    
    func set(name: String) {
        nameLabel.text = name
    }
    
    func set(university: String) {
        detailLabel.text = university
    }
    
    func set(url: URL?) {
        userImageView.sd_setImage(with: url, placeholderImage: nil)
        hoverView.isHidden = true
        addPhotoButton.isHidden = true
        changePhotoButton.isHidden = true
    }
}

// MARK: - Actions
extension ClubHeader {

    @IBAction func changePhotoButtonAction(_ sender: Any) {
        delegate?.addPhotoOfClub()
    }
    
    @IBAction func addPhotoButtonAction(_ sender: Any) {
        delegate?.addPhotoOfClub()
    }
    
    @IBAction func infoButtonAction() {
        delegate?.infoOfClub()
    }
    
    @IBAction func nameTapButtonAction() {
        delegate?.infoOfClub()
    }
}
