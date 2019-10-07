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
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
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
        DispatchQueue.main.async{
            self.cameraBtn.backgroundColor=UIColor.clear
            self.cameraBtn.tintColor=UIColor.clear
            self.cameraBtn.imageView?.image = image
        }
    }
    
    func setup(url: URL?) {
        cameraBtn.imageView?.sd_setImage(with: url, completed: nil)
    }
    
    func setup(imageUrl: URL?) {
        cameraBtn.imageView?.sd_setImage(with: imageUrl, completed: nil)
    }

}

// MARK: - Actions
extension EditProfileImageCell {

//    @IBAction func changePhotoButtonAction(_ sender: Any) {
//        delegate?.addPhotoOfClub()
//    }
    
    @IBAction func addPhotoButtonAction(_ sender: Any) {
        delegate?.addPhotoOfProfile()
    }
    
//    @IBAction func infoButtonAction() {
//        delegate?.infoOfClub()
//    }
//
//    @IBAction func nameTapButtonAction() {
//        delegate?.infoOfClub()
//    }
}
