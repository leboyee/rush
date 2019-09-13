//
//  DynamicHeightCollectionView.swift
//  DynamicHeightCollectionView
//
//  Created by Kamal Mittal on 03/07/18.
//  Copyright © 2018 -. All rights reserved.
//

import UIKit

class DynamicHeightCollectionView: UICollectionView {
    override func layoutSubviews() {
        super.layoutSubviews()
        if !__CGSizeEqualToSize(bounds.size, self.intrinsicContentSize) {
            self.invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
