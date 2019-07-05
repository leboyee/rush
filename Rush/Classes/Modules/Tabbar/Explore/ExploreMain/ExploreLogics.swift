//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ExploreViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNormalMagnitude : 50
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 8
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 157
        }
    }
    
    func cellCount(_ section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 1
        }
    }
    
    
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        if indexPath.section == 1 {
            cell.setup(.upcoming, nil)
        } else if indexPath.section == 2 {
            cell.setup(.clubs, nil)
        } else {
            cell.setup(.classes, nil)
        }
    }
    
    func fillExploreCell(_ cell: ExploreCell, _ indexPath: IndexPath) {
        
    }
    
    func fillTextHeader(_ header: TextHeader,_ section: Int) {
        if section == 1 {
            header.setup(title: Text.todayEvent)
        } else if section == 2 {
            header.setup(title: Text.clubsMightLike)
        } else if section == 3 {
            header.setup(title: Text.classesYouMightLike)
        }
        
        header.detailButtonClickEvent = { [weak self] () in
            guard let self_ = self else { return }
            // Open other user profile UI for test
            
            if section == 2 {
                self_.performSegue(withIdentifier: Segues.clubListSegue , sender: ClubListType.club)
            } else if section == 3 {
                self_.performSegue(withIdentifier: Segues.clubListSegue , sender: ClubListType.classes)
            } else {
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
}
