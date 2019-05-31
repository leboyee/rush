//
//  PhotoTableViewCell.swift
//  Profile
//
//  Created by ideveloper on 24/08/18.
//  Copyright © 2018 Messapps. All rights reserved.
//

import UIKit

enum CellType {
    case none
    case event
    case clubUser
    case profileImage
}

class EventTypeCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellSelected: ((_ type : EventCategoryType,_ id: Int,_ index: Int) -> Void)?
    
    var type : EventCategoryType = .upcoming
    var cellType : CellType = .none
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Cell.event, bundle: nil), forCellWithReuseIdentifier: Cell.event)
        collectionView.register(UINib(nibName: Cell.user, bundle: nil), forCellWithReuseIdentifier: Cell.user)
        collectionView.register(UINib(nibName: Cell.profileImage, bundle: nil), forCellWithReuseIdentifier: Cell.profileImage)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ type : EventCategoryType, _ photos: [Image]?) {
        cellType = .event
        self.type = type
        reload()
    }
    
    func setup(userList: [String]) {
        cellType = .clubUser
    }
    
    func setup(imagesList:[UIImage]) {
        cellType = .profileImage
    }
    
}
