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
        tableView.register(reusableViewName: ReusableView.textHeader)
        tableView.contentInset = UIEdgeInsets(top: headerFullHeight, left: 0, bottom: 50, right: 0)
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
        if indexPath.section == 3 {
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
        
        let smallHeight = headerSmallHeight + (AppDelegate.shared?.window?.safeAreaInsets.top ?? 0)
        let y = headerFullHeight - (scrollView.contentOffset.y + headerFullHeight)
        let height = min(max(y, smallHeight), screenHeight)
        self.headerHeightConstraint.constant = height
        print(height)
    }
    
}

extension ProfileViewController: ParallaxHeaderDelegate {
    func editProfileEvent() {
        showEditProfile()
    }
}
