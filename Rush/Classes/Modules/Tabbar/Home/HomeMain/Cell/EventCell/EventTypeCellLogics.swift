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
        if cellType == .interests || cellType == .friends || cellType == .invitees || (cellType == .event && type == .clubs) { // after stable app (remove this line)
            return cellType == .invitees ? (list?.count ?? 0) + 1 : (list?.count ?? 0)
        } else if type == .upcoming {
            return list?.count ?? 0
        }
        return 10
    }
    
    func fillEventCell(_ cell: EventCell, _ indexPath: IndexPath) {
        cell.setup(type: type)
        if type == .upcoming {
            if let eventList = list as? [Event] {
                let event = eventList[indexPath.item]
                cell.setup(eventName: event.title)
                cell.setup(eventType: event.eventType)
                if event.photoJson.isNotEmpty {
                    cell.setup(eventImageUrl: event.photoJson.photo?.url())
                }
            } else {
                cell.setup(eventName: "VR Meetup")
                cell.setup(eventDetail: "10-12pm")
            }
        } else if type == .clubs || type == .clubsJoined {
            if let clubList = list as? [Club] {
                let club = clubList[indexPath.item]
                cell.setup(eventName: club.clubName ?? "")
                cell.setup(eventDetail: club.clubDesc ?? "")
                let img = Image(json: club.clubPhoto ?? "")
                cell.setup(eventImageUrl: img.url())
                let clubId = club.clubUserId
                let userId = Authorization.shared.profile?.userId ?? ""
                if clubId == userId {
                    cell.setup(type: .clubsJoined)
                    cell.setup(invitee: club.invitees)
                }
            } else {
                cell.setup(eventName: "Development lifehacks")
                cell.setup(eventDetail: "Get the latest dev skills")
            }
        } else if type == .classes {
            
        }
        
    }
    
    func fillUserCell(_ cell: UserCell, _ indexPath: IndexPath) {
        if indexPath.item == 0 {
            cell.setup(text: Text.viewAll)
            cell.setup(image: Text.viewAll)
            cell.setup(count: list?.count ?? 0)
            cell.setup(isShowCount: true)
        } else {
            if let invitee = list?[indexPath.item - 1] as? Invitee {
                cell.setup(text: (invitee.user?.firstName ?? "") + " " + (invitee.user?.lastName ?? ""))
                cell.setup(isShowCount: false)
                cell.setup(url: invitee.user?.photo?.urlThumb())
            }
        }
    }
    
    func fillFriendCell(_ cell: UserCell, _ indexPath: IndexPath) {
        if let friend = list?[indexPath.row] as? Friend {
            cell.setup(text: friend.user?.firstName ?? "")//***
            cell.setup(url: friend.user?.photo?.urlThumb())
            cell.setup(isShowCount: false)
        }
    }
    
    func fillInterestCell(_ cell: TextCell, _ indexPath: IndexPath) {
        if let tag = list?[indexPath.row] as? Tag {
            cell.setup(text: tag.text)
        }
    }
    
    func fillImagesCell(_ cell: ProfileImageCell, _ indexPath: IndexPath) {
        
    }
    
    func cellSelectedEvent(_ indexPath: IndexPath) {
         if cellType == .invitees {
             userSelected?(0, indexPath.item)
         } else {
             cellSelected?(self.type, 0, indexPath.item)
         }
    }
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        if cellType == .interests {
            guard list?.count ?? 0 > indexPath.row else { return CGSize.zero }
            if let tag = list?[indexPath.row] as? Tag {
                var textWidth =  ceil(tag.text.widthOfString(usingFont: UIFont.semibold(sz: 13.0)))
                //Add Padding
                textWidth += (padding*2)
                let height: CGFloat = 28.0
                return CGSize(width: textWidth, height: height)
            }
            return CGSize.zero
        } else if cellType == .event {
            return CGSize(width: 224, height: 157)
        } else if cellType == .invitees || cellType == .friends {
            return CGSize(width: 72, height: 88)
        } else {
            return CGSize(width: 96, height: 112)
        }
    }
}
