//
//  HomeMediates.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension OtherUserProfileController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        tableView.register(UINib(nibName: Cell.question, bundle: nil), forCellReuseIdentifier: Cell.question)
        tableView.register(UINib(nibName: Cell.clubManage, bundle: nil), forCellReuseIdentifier: Cell.clubManage)
        tableView.register(UINib(nibName: Cell.eventType, bundle: nil), forCellReuseIdentifier: Cell.eventType)
        tableView.register(UINib(nibName: Cell.noEventCell, bundle: nil), forCellReuseIdentifier: Cell.noEventCell)
        tableView.register(cellName: Cell.noEventLabel)
        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
        tableView.reloadData()
        
        fillImageHeader()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isShowEmptyPlaceholder(indexPath.section) {
            if indexPath.section == 2 || indexPath.section == 3 {
                guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Cell.noEventLabel,
                for: indexPath) as? NoEventsCell else { return UITableViewCell() }
                fillPlaceholderCell(cell, indexPath.section)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.noEventCell, for: indexPath) as? NoEventsCell else { return UITableViewCell() }
                fillPlaceholderCell(cell, indexPath.section)
                return cell
            }
        } else {
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.clubManage, for: indexPath) as? ClubManageCell else { return UITableViewCell() }
                fillManageCell(cell, indexPath)
                return cell
            } else if indexPath.section == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.question, for: indexPath) as? QuestionCell else { return UITableViewCell() }
                fillRsvpQuestionCell(cell, indexPath)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventType, for: indexPath) as? EventTypeCell else { return UITableViewCell() }
                fillEventCell(cell, indexPath)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = UIView()
        let separator = UIView(frame: CGRect(x: (section == 0 || (section == 1 && (rsvpQuestion?.count ?? 0) > 0)) ?  0 : 24, y: 0, width: screenWidth, height: 1))
        if section != 6 {
            footer.addSubview(separator)
        }
        footer.clipsToBounds = true
        separator.backgroundColor = UIColor.separatorColor
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightOfFooter(section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return UIView()
        } else {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.textHeader) as? TextHeader else { return UIView() }
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

// MARK: - Notification alert delegate
extension OtherUserProfileController: NotificationAlertDelegate {
    func undoButtonClickEvent() {
        friendType = .friends
        tableView.reloadData()
    }
}

// MARK: - Header delegates
extension OtherUserProfileController: UIScrollViewDelegate, ClubHeaderDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topMergin = (AppDelegate.shared?.window?.safeAreaInsets.top ?? 0)
        let smallHeaderHeight = headerSmallWithDateHeight
        let smallHeight = smallHeaderHeight + topMergin
        let h = heightConstraintOfHeader.constant - scrollView.contentOffset.y
        let height = min(max(h, smallHeight), screenHeight)
        self.heightConstraintOfHeader.constant = height
        if !smallHeight.isEqual(to: height) {
            tableView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.heightConstraintOfHeader.constant > headerFullHeight {
            animateHeader()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.heightConstraintOfHeader.constant > headerFullHeight {
            animateHeader()
        }
    }
    
    private func animateHeader() {
        self.heightConstraintOfHeader.constant = headerFullHeight
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func fillImageHeader() {
        header.delegate = self
        header.setup(profileUrl: userInfo?.photo?.urlLarge())
        header.set(name: userInfo?.name ?? "")
        header.set(university: userInfo?.university?.first?.universityName ?? "")
    }
    
    func addPhotoOfClub() { }
    
    func infoOfClub() {
        performSegue(withIdentifier: Segues.profileInformation, sender: nil)
    }
}

// MARK: - SharePostViewControllerDelegate
extension OtherUserProfileController: SharePostViewControllerDelegate {
    func delete(type: SharePostType, object: Any?) {
        
    }
    
    func shareObject(_ object: Any?) {
        var data = [Any]()
        
        data.append("Check out \(userInfo?.name ?? "") on Rush app")
        if let clubImage = header.userImageView.image {
            data.append(clubImage)
        }
        Utils.openActionSheet(controller: self, shareData: data)
    }
}
