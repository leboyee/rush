//
//  ClubListLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ClubListViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        return 50
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 8
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && isShowJoinEvents {
            return UITableView.automaticDimension
        } else {
            return 157
        }
    }
    
    func cellCount(_ section: Int) -> Int {
        if isShowJoinEvents && section == 0 {
            return 4
        } else {
            return 1
        }
    }
    
    
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        if indexPath.section == 1 {
            cell.setup(.clubs, nil)
        } else if indexPath.section == 2 {
            cell.setup(.clubs, nil)
        } else {
            cell.setup(.clubs, nil)
        }
    }
    
    func fillMyClubCell(_ cell: FriendClubCell, _ indexPath: IndexPath) {
        if indexPath.row == 0 {
            cell.setup(topConstraint: -16)
        } else {
            cell.setup(topConstraint: 0)
        }
    }
    
    func fillTextHeader(_ header: TextHeader,_ section: Int) {
        header.setup(isDetailArrowHide: false)
        if section == 0 {
            header.setup(title: Text.myClubs)
            header.setup(isDetailArrowHide: true)
        } else if section == 1 {
            header.setup(title: "Sports")
        } else if section == 2 {
            header.setup(title: "Art")
        } else if section == 3 {
            header.setup(title: "Technologies")
        }
        
        header.detailButtonClickEvent = { [weak self] () in
            guard let self_ = self else { return }
            // Open other user profile UI for test
            
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: ViewControllerId.createPostViewController) as! CreatePostViewController
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.view.backgroundColor = UIColor.bgBlack
            let navigation = UINavigationController(rootViewController: vc)
            self_.navigationController?.present(navigation, animated: true, completion: nil)
//            self_.performSegue(withIdentifier: Segues.openPostScreen , sender: nil)
        }
    }
}
