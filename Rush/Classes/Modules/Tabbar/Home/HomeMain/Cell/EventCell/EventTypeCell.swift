//
//  PhotoTableViewCell.swift
//  Profile
//
//  Created by ideveloper on 24/08/18.
//  Copyright © 2018 Messapps. All rights reserved.
//

import UIKit

class EventTypeCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var cellSelected: ((_ type : EventCategoryType,_ id: Int,_ index: Int) -> Void)?
    var type : EventCategoryType = .upcoming
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Cell.event, bundle: nil), forCellWithReuseIdentifier: Cell.event)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ type : EventCategoryType, _ photos: [Image]?) {
        self.type = type
        reload()
//        setupCollectionView()
    }
    
    
}
