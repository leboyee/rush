//
//  ChatUserView.swift
//  Rush
//
//  Created by ideveloper on 05/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class ChatUserView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var contentView: UIView!
    
    var isShowAll = false
    
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
        
        self.contentView.backgroundColor = isDarkModeOn ? UIColor.bgBlack17 : UIColor.bgWhite96
        
        collectionView.register(UINib(nibName: Cell.chatUserCell, bundle: nil), forCellWithReuseIdentifier: Cell.chatUserCell)
        
        collectionView.reloadData()
    }
}

//MARK: - CollectionView delegate methods
extension ChatUserView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isShowAll ? 10 : 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.chatUserCell, for: indexPath) as! ChatUserCell
        if indexPath.item == 6 && isShowAll == false {
            cell.setup(isHideArrowView: false)
        } else {
            cell.setup(isHideArrowView: true)
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
