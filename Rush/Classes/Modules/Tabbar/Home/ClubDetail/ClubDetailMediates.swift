//
//  HomeMediates.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit


extension ClubDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        let headerNib =   UINib(nibName: ReusableView.userImagesHeader, bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: ReusableView.userImagesHeader)
        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
        
        let cells = [Cell.clubName, Cell.clubManage, Cell.createUserPost, Cell.tag, Cell.eventByDate, Cell.eventType, Cell.singleButtonCell, Cell.userPostText, Cell.userPostImage, Cell.postLikeCell]
        
        for cell in cells {
            tableView.register(UINib(nibName: cell, bundle: nil), forCellReuseIdentifier: cell)
        }
        
        tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return joinedClub ? (6 + clubPostList.count) : 6
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
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventType, for: indexPath) as! EventTypeCell
            fillJoinedUserCell(cell)
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventByDate, for: indexPath) as! EventByDateCell
            fillEventByDateCell(cell, indexPath)
            return cell
        } else if indexPath.section == 4 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.tag, for: indexPath) as! TagCell
            fillTagCell(cell)
            return cell
        } else if indexPath.section == 5 {
            if joinedClub {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cell.createUserPost, for: indexPath) as! CreateUserPostCell
                cell.setup(font: UIFont.Semibold(sz: 13))
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
        let separator = UIView(frame: CGRect(x: section == 2 ?  24 : 0, y: 0, width: screenWidth, height: 1))
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
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.textHeader) as! TextHeader
            fillTextHeader(header, section)
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightOfHeader(section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return cellHeight(indexPath)
    }
}

//MARK: - OtherUserProfile delegate
extension ClubDetailViewController: OtherUserProfileProtocol {
    func unfriendUser(_ name: String) {
        let snackbar = TTGSnackbar(message: "You unfriended \(name)",
            duration: .middle,
            actionText: "Undo",
            actionBlock: { (snackbar) in
                Utils.notReadyAlert()
        })
        snackbar.show()
    }
}
