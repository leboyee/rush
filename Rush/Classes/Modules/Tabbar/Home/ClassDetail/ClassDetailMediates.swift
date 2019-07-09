//
//  HomeMediates.swift
//  Rush
//
//  Created by Chirag on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit


extension ClassDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        let headerNib =   UINib(nibName: ReusableView.userImagesHeader, bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: ReusableView.userImagesHeader)
        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
        
        let cells = [Cell.clubName, Cell.clubManage, Cell.createUserPost, Cell.timeSlot, Cell.eventByDate, Cell.eventType, Cell.singleButtonCell, Cell.userPostText, Cell.userPostImage, Cell.postLikeCell, Cell.textIcon]
        
        for cell in cells {
            tableView.register(UINib(nibName: cell, bundle: nil), forCellReuseIdentifier: cell)
        }
        
        tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return joinedClub ? (6 + classesPostList.count) : 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.clubName, for: indexPath) as! ClubNameCell
            fillClubNameCell(cell)
            return cell
        } else if indexPath.section == 1 {
            if joinedClub {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.clubManage, for: indexPath) as! ClubManageCell
                fillClubManageCell(cell)
                return cell
            } else {
                return UITableViewCell()
            }
        } else if indexPath.section == 2 || indexPath.section == 3 {
            if indexPath.section == 2 && isShowMore {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.timeSlot, for: indexPath) as! TimeSlotCell
                fillTimeSlotCell(cell, indexPath)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.textIcon, for: indexPath) as! TextIconCell
                fillTimeCell(cell, indexPath)
                return cell
            }
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventType, for: indexPath) as! EventTypeCell
            fillJoinedUserCell(cell)
            return cell
        } else if indexPath.section == 5 {
            if joinedClub {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.createUserPost, for: indexPath) as! CreateUserPostCell
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.singleButtonCell, for: indexPath) as! SingleButtonCell
                fillSingleButtonCell(cell)
                return cell
            }
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventByDate, for: indexPath) as! EventByDateCell
                fillEventByDateCell(cell, indexPath)
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.userPostText, for: indexPath) as! UserPostTextTableViewCell
                fillTextViewCell(cell)
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.userPostImage, for: indexPath) as! UserPostImageTableViewCell
                fillImageCell(cell, indexPath)
                return cell
            } else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.postLikeCell, for: indexPath) as! PostLikeCell
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected(indexPath)
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = UIView()
        if (section == 2 && isShowMore == false) || section == 3 {
            return footer
        }
        let separator = UIView(frame: CGRect(x: (section == 2 && isShowMore == false) ?  24 : 0, y: (isShowMore && section == 2) ? 15 : 0, width: screenWidth, height: 1))
        footer.addSubview(separator)
        separator.backgroundColor = UIColor.separatorColor
        return footer
    }
     
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightOfFooter(section)
      }
     
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.userImagesHeader) as! UserImagesHeaderView
            fillImageHeader(view)
            return view
        } else {
            
            if (section == 2 || section == 3) {
                return UIView()
            } else {
                let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.textHeader) as! TextHeader
                fillTextHeader(header, section)
                return header
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightOfHeader(section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return cellHeight(indexPath)
    }
}
