//
//  ChatUserView.swift
//  Rush
//
//  Created by ideveloper on 05/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import SendBirdSDK

class ChatUserView: UIView {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    var isShowAll = false
    var users = [SBDUser]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("ChatUserView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        clipsToBounds = true
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        // bottom padding 62 and + (34 bottom safearea height)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        noDataLabel.isHidden = users.count > 0
        
        self.contentView.backgroundColor = isDarkModeOn ? UIColor.bgBlack17 : UIColor.bgWhite96
        
        collectionView.register(UINib(nibName: Cell.chatUserCell, bundle: nil), forCellWithReuseIdentifier: Cell.chatUserCell)
        
        collectionView.reloadData()
    }
    
    func reloadData(users: [SBDUser]) {
        self.users = users
        noDataLabel.isHidden = users.count > 0
        collectionView.reloadData()
    }
}

// MARK: - CollectionView delegate methods
extension ChatUserView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if users.count > 6 {
            return isShowAll ? users.count : 7
        } else {
            return users.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.chatUserCell, for: indexPath) as? ChatUserCell else { return UICollectionViewCell() }
        
        if indexPath.item == 6 && isShowAll == false {
            cell.setup(isHideArrowView: false)
            cell.onlineView.isHidden = true
        } else {
            cell.onlineView.isHidden = false
            cell.setup(isHideArrowView: true)
        }
        
        let user = users[indexPath.item]
        cell.setup(img: user.profileUrl)
        
        if user.connectionStatus == .online {
            cell.onlineView.isHidden = false
        } else {
            cell.onlineView.isHidden = true
        }
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 6 {
            isShowAll = true
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 32, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return ((screenWidth) - (32 * 7)) / 6 - 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
