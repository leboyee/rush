//
//  ProfileMediator.swift
//  Rush
//
//  Created by kamal on 14/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ProfileViewController {
   
    func setupTableView() {
        tableView.layer.cornerRadius = topViewRadius
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(cellName: Cell.notification)
        tableView.register(cellName: Cell.eventType)
        tableView.register(cellName: Cell.noEventLabel)

        tableView.register(reusableViewName: ReusableView.textHeader)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.reloadData()
    }
    
    func setupHeader() {
        /// setup header
        header.delegate = self
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isRequiresEmptyCell(indexPath.section) {
           if let cell = tableView.dequeueReusableCell(
                withIdentifier: Cell.noEventLabel,
                for: indexPath) as? NoEventsCell {
                fillEmptyCell(cell, indexPath)
                return cell
            }
        } else if indexPath.section == 3 {
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: Cell.notification,
                for: indexPath) as? NotificationCell {
                fillNotificationCell(cell, indexPath)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: Cell.eventType,
                for: indexPath) as? EventTypeCell {
                fillEventTypeCell(cell, indexPath)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplay(indexPath)
    }

    // MARK: - Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight(section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: ReusableView.textHeader
            ) as? TextHeader {
            fillTextHeader(header, section)
            return header
        }
        return nil
    }
    
    // MARK: - Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // MARK: - Scroll Delegates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topMergin = (AppDelegate.shared?.window?.safeAreaInsets.top ?? 0)
        let smallHeight = headerSmallHeight + topMergin
        let h = headerHeightConstraint.constant - scrollView.contentOffset.y
        let height = min(max(h, smallHeight), screenHeight)
        self.headerHeightConstraint.constant = height
        if !smallHeight.isEqual(to: height) {
            tableView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerHeightConstraint.constant > headerFullHeight {
            animateHeader()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerHeightConstraint.constant > headerFullHeight {
            animateHeader()
        }
    }
    
}

extension ProfileViewController {
    private func animateHeader() {
        self.headerHeightConstraint.constant = headerFullHeight
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
}

extension ProfileViewController: ParallaxHeaderDelegate {
    func editProfileEvent() {
        showEditProfile()
    }
}

// MARK: - OtherUserProfile delegate
extension ProfileViewController: OtherUserProfileProtocol {
    func unfriendUser(_ name: String) {
        /*
        /// Comment that part for now, will open again after discussion
        let snackbar = TTGSnackbar(message: "You unfriended \(name)",
            duration: .middle,
            actionText: "Undo",
            actionBlock: { (_) in
                Utils.notReadyAlert()
        })
        snackbar.show()
        */
        loadFriends()
    }
}
