//
//  EditProfileImageCell.swift
//  Rush
//
//  Created by Suresh Jagnani on 04/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

protocol AddImageDelegate: class {
    func addPhotoOfProfile()
}

class EditProfileImageCell: UITableViewCell {

    weak var delegate: AddImageDelegate?
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension EditProfileImageCell {
    
    func setup(image: UIImage?) {
        DispatchQueue.main.async {
            self.cameraButton.backgroundColor=UIColor.clear
            self.cameraButton.tintColor=UIColor.clear
            self.cameraButton.imageView?.image = image
        }
    }
    
    func setup(url: URL) {
        cameraButton?.sd_setBackgroundImage(with: url, for: .normal, completed: { (image, _, _, _) in
            if image != nil {
                self.titleLabel.text = "Change profile image"
                self.setup(image: UIImage())
            } else {
                self.titleLabel.text = "Add profile image"
                self.setup(image: #imageLiteral(resourceName: "addProfile"))
            }
        })
    }
    
    func setup(image: UIImage) {
        cameraButton.setImage(image, for: .normal)
    }

}

// MARK: - Actions
extension EditProfileImageCell {
    
    @IBAction func addPhotoButtonAction(_ sender: Any) {
        delegate?.addPhotoOfProfile()
    }
}
