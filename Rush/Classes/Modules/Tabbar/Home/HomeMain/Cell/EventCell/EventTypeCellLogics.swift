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
        if cellType == .profileImage || cellType == .interests || cellType == .friends || cellType == .invitees || (cellType == .event && type == .clubs)  || type == .clubsJoined || cellType == .event {
            return cellType == .invitees ? (list?.count ?? 0) + 1 : (list?.count ?? 0)
        } else if type == .upcoming || type == .classes {
            return list?.count ?? 0
        }
        return 5
    }
    
    func fillEventCell(_ cell: EventCell, _ indexPath: IndexPath) {
        cell.setup(type: type)
        
        if type == .upcoming {
            if let eventList = list as? [Event] {
                let event = eventList[indexPath.item]
                cell.setup(eventName: event.title)
                cell.setup(eventType: event.eventType)
                cell.setup(date: event.start)
                cell.setup(start: event.start, end: event.end)
                let filter = event.invitees?.filter({ $0.user?.userId == Authorization.shared.profile?.userId })
                if filter?.count ?? 0 > 0 {
                    cell.setup(invitee: event.invitees)
                    cell.setup(isHideInvitee: false)
                } else {
                    cell.setup(isHideInvitee: true)
                }
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
                cell.setup(clubImageUrl: img.url())
                cell.joinButton.isHidden = false
                
                var isJoined = false
                if let invitee = club.invitees {
                    let filter = invitee.filter({ $0.user?.userId == Authorization.shared.profile?.userId })
                    if filter.count > 0 {
                        isJoined = true
                    }
                }
                
                let clubUserId = club.clubUId
                let userId = Authorization.shared.profile?.userId ?? ""
                if clubUserId == userId {
                    isJoined = true
                }
                
                if isJoined {
                    cell.setup(type: .clubsJoined)
                    cell.setup(invitee: club.invitees)
                }
            } else {
                cell.setup(eventName: "Development lifehacks")
                cell.setup(eventDetail: "Get the latest dev skills")
            }
        } else if type == .classes {
            if let classList = list as? [Class] {
                let value = classList[indexPath.item]
                cell.setup(className: value.name)
            } else if let classList = list as? [SubClass] {
                let value = classList[indexPath.item]
                cell.setup(className: value.name)
                cell.setup(classImageUrl: value.photo?.url())
                if value.myJoinedClass?.count ?? 0 > 0 {
                    let groupid = value.myJoinedClass?[0].groupId
                    let group = value.classGroups?.filter { $0.id == groupid }.first
                    cell.setup(classCount: group?.name ?? "")
                } else {
                    cell.setup(classCount: "\(value.classTotalGroups) classes")
                }
            } else if let classList = list as? [ClassJoined] {
                let joinedClass = classList[indexPath.item]
                cell.setup(className: joinedClass.classes?.name ?? "")
                cell.setup(classImageUrl: joinedClass.classes?.photo?.url())
                cell.setup(classCount: joinedClass.classGroup?.name ?? "")
            }
        }
        cell.joinSelected = { [weak self] () in
            guard let unsafe = self else { return }
            unsafe.joinSelected?(indexPath.row)
        }
    }
   
    func fillUserCell(_ cell: UserCell, _ indexPath: IndexPath) {
        if indexPath.item == 0 {
            cell.setup(text: Text.viewAll)
            cell.setup(image: Text.viewAll)
            cell.setup(count: total)
            cell.setup(isShowCount: true)
        } else {
            if let invitee = list?[indexPath.item - 1] as? Invitee {
                cell.setup(text: (invitee.user?.firstName ?? ""))
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
        if let interest = list?[indexPath.row] as? Interest {
            cell.setup(text: interest.interestName)
        }
    }
    
    func fillImagesCell(_ cell: ProfileImageCell, _ indexPath: IndexPath) {
        guard list?.count ?? 0 > indexPath.row else { return }
        if let image = list?[indexPath.row] as? Image {
            cell.set(url: image.urlThumb())
        }
    }
    
    func cellSelectedEvent(_ indexPath: IndexPath) {
         if cellType == .invitees {
             userSelected?(0, indexPath.item)
         } else {
             cellSelected?(self.type, indexPath.section, indexPath.item)
         }
    }
    
    func cellSize(indexPath: IndexPath) -> CGSize {
        if cellType == .interests {
            guard list?.count ?? 0 > indexPath.row else { return CGSize.zero }
            if let tag = list?[indexPath.row] as? Interest {
                var textWidth =  ceil(tag.interestName.widthOfString(usingFont: UIFont.semibold(sz: 13.0)))
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
