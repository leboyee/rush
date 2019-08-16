//
//  PhotoTableViewCellPresenter.swift
//  AutoBuyer
//
//  Created by ideveloper on 23/01/18.
//  Copyright © 2018 Messapps. All rights reserved.
//

import UIKit

extension EventTypeCell {
    
    func cellCount(_ section: Int) -> Int {
        if cellType == .interests || cellType == .friends {
            return list?.count ?? 0
        }
        return 10
    }
    
    func fillEventCell(_ cell: EventCell,_ indexPath: IndexPath) {
        cell.setup(type: type)
        if type == .upcoming {
            cell.setup(eventName: "VR Meetup")
            cell.setup(eventDetail: "10-12pm")
        } else if type == .clubs || type == .clubsJoined {
            cell.setup(eventName: "Development lifehacks")
            cell.setup(eventDetail: "Get the latest dev skills")
        } else if type == .classes {
            
        }
        
    }
    
    func fillUserCell(_ cell: UserCell,_ indexPath: IndexPath) {
        if indexPath.item == 0 {
            cell.setup(text: Text.viewAll)
            cell.setup(image: Text.viewAll)
            cell.setup(isShowCount: true)
        } else {
            cell.setup(text: "John")
            cell.setup(isShowCount: false)
        }
    }
    
    func fillFriendCell(_ cell: UserCell,_ indexPath: IndexPath) {
        if let friend = list?[indexPath.row] as? Friend {
            cell.setup(text: friend.firstName)
            cell.setup(url: friend.photo?.urlThumb)
            cell.setup(isShowCount: false)
        }
    }
    
    
    func fillInterestCell(_ cell: TextCell,_ indexPath: IndexPath) {
        if let tag = list?[indexPath.row] as? Tag {
            cell.setup(text: tag.text)
        }
    }
    
    func fillImagesCell(_ cell: ProfileImageCell,_ indexPath: IndexPath) {
        
    }
    
    func cellSelectedEvent(_ indexPath: IndexPath) {
        self.cellSelected?(self.type, 0, indexPath.item)
    }
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        if cellType == .interests {
            if let tag = list?[indexPath.row] as? Tag {
                var textWidth =  ceil(tag.text.widthOfString(usingFont: UIFont.Semibold(sz: 13.0)))
                //Add Padding
                textWidth += (padding*2)
                let height: CGFloat = 28.0
                return CGSize(width: textWidth, height: height)
            }
            return CGSize.zero
        } else if cellType == .event {
            return CGSize(width: 224, height: 157)
        } else if cellType == .clubUser || cellType == .friends {
            return CGSize(width: 72, height: 88)
        } else {
            return CGSize(width: 96, height: 112)
        }
    }
}
