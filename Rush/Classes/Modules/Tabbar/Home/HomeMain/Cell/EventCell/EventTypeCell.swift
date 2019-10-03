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
    case invitees
    case profileImage
    case friends
    case interests

}

class EventTypeCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var separator: UIView!

    var cellSelected: ((_ type: EventCategoryType, _ id: Int, _ index: Int) -> Void)?
    var userSelected: ((_ id: Int, _ index: Int) -> Void)?
    
    var type: EventCategoryType = .upcoming
    var cellType: CellType = .none
    var list: [Any]?
    let padding: CGFloat = 16.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Cell.event, bundle: nil), forCellWithReuseIdentifier: Cell.event)
        collectionView.register(UINib(nibName: Cell.user, bundle: nil), forCellWithReuseIdentifier: Cell.user)
        collectionView.register(UINib(nibName: Cell.profileImage, bundle: nil), forCellWithReuseIdentifier: Cell.profileImage)
        collectionView.register(UINib(nibName: Cell.text, bundle: nil), forCellWithReuseIdentifier: Cell.text)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ type: EventCategoryType, _ photos: [Image]?, _ dataList: [Any]?) {
        cellType = .event
        self.type = type
        list = dataList
        reload()
    }
    
    func setup(invitees: [Invitee]?) {
        cellType = .invitees
        list = invitees
        reload()
    }
    
    func setup(friends: [Friend]) {
        cellType = .friends
        list = friends
        reload()
    }
    
    func setup(interests: [Tag]) {
        cellType = .interests
        list = interests
        reload()
    }
    
    func setup(imagesList: [Image]) {
        cellType = .profileImage
        list = imagesList
        reload()
    }
    
    func setup(isSeparatorHide: Bool) {
        separator.isHidden = isSeparatorHide
    }
}
