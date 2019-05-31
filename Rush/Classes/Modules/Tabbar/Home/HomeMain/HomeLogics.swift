//
//  HomeLogics.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension HomeViewController {
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        return section == 0 ? CGFloat.leastNormalMagnitude : 50
    }
    
    func heightOfFooter(_ section: Int) -> CGFloat {
        return 8
    }
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return isShowTutorial ? UITableView.automaticDimension : CGFloat.leastNormalMagnitude
        } else if indexPath.section == 1 && isShowJoinEvents {
            return UITableView.automaticDimension
        } else {
            return 157
        }
    }
    
    func cellCount(_ section: Int) -> Int {
        if isShowJoinEvents && section == 1 {
            return 4
        } else {
            return 1
        }
    }
    
    
    func fillTutorialCell(_ cell: TutorialPopUpCell) {
        
        cell.setup(text: "Join events and classes to see your schedual in Calendar.")
        cell.setup(bgImage: "popup-green-left")
        cell.setup(buttonTitle: "OK")
        
        cell.okButtonClickEvent = { [weak self] (text) in
            guard let self_ = self else { return }
            if text == "OK" {
                cell.setup(text: "Create events and open clubs")
                cell.setup(bgImage: "popup-green-right")
                cell.setup(buttonTitle: "Nice!")
            } else {
                self_.isShowTutorial = false
                self_.tableView.reloadData()
            }
        }
    }
    
    func fillEventTypeCell(_ cell: EventTypeCell, _ indexPath: IndexPath) {
        if indexPath.section == 1 {
            cell.setup(.upcoming, nil)
        } else if indexPath.section == 2 {
            cell.setup(isShowJoinEvents ? .clubsJoined : .clubs, nil)
        } else {
            cell.setup(.classes, nil)
        }
    }
    
    func fillEventByDateCell(_ cell: EventByDateCell, _ indexPath: IndexPath) {
        
    }
    
    func fillTextHeader(_ header: TextHeader,_ section: Int) {
        if section == 1 {
            header.setup(title: "Upcoming events")
        } else if section == 2 {
            header.setup(title: "Clubs")
        } else if section == 3 {
            header.setup(title: "Classes")
        }
        
        header.detailButtonClickEvent = { [weak self] () in
            guard let self_ = self else { return }
            // Open other user profile UI for test
            self_.performSegue(withIdentifier: Segues.otherUserProfile , sender: nil)
        }
    }
    
    
}
