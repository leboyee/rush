//
//  OnboardingLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension OnboardingViewController {
    
    
    func fillCell(cell: OnBoardingCollectionViewCell, indexPath: IndexPath) {
        cell.setup(index: indexPath.row)
    }
    
    func pageIndex(index: Int) {
        self.pageControl.currentPage = index
    }
}
