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
    
    var cellSelected: ((_ type : EventType,_ id: Int,_ index: Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setup(_ type : EventType, _ photos: [Image]?) {
        
    }
    
}
