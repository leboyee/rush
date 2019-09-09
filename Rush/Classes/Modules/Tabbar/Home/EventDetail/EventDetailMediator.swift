//
//  EventDetailMediator.swift
//  Rush
//
//  Created by kamal on 27/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension EventDetailViewController {
    
    func setupTableView() {
        tableView.layer.cornerRadius = topViewRadius
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 400.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: Cell.eventAbout, bundle: nil), forCellReuseIdentifier: Cell.eventAbout)
        tableView.register(UINib(nibName: Cell.eventType, bundle: nil), forCellReuseIdentifier: Cell.eventType)
        tableView.register(UINib(nibName: Cell.clubManage, bundle: nil), forCellReuseIdentifier: Cell.clubManage)
        tableView.register(UINib(nibName: Cell.location, bundle: nil), forCellReuseIdentifier: Cell.location)
        tableView.register(UINib(nibName: Cell.createPost, bundle: nil), forCellReuseIdentifier: Cell.createPost)
        
        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
        //tableView.contentInset = UIEdgeInsets(top: headerFullHeight, left: 0, bottom: 0, right: 0)
        tableView.reloadData()
    }
    
    func setupHeader() {
        /// setup header
        //header.delegate = self
    }
    
}

extension EventDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        let type = sectionType(section: indexPath.section)
        
        if type == .about {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventAbout, for: indexPath) as? EventAboutCell {
                fillAboutCell(cell, indexPath)
                return cell
            }
        } else if type == .manage {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.clubManage, for: indexPath) as? ClubManageCell {
                fillManageCell(cell)
                return cell
            }
        } else if type == .location {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.location, for: indexPath) as? LocationCell {
                fillLocationCell(cell)
                return cell
            }
        } else if type == .createPost {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.createPost, for: indexPath) as? CreatePostCell {
                fillCreatePostCell(cell)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventType, for: indexPath) as? EventTypeCell {
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
        
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.textHeader) as? TextHeader {
            fillTextHeader(header, section)
            return header
        }
        return nil
    }
    
    // MARK: - Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return RSeparatorLine()
    }
    
    // MARK: - Scroll Delegates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topMergin = (AppDelegate.shared?.window?.safeAreaInsets.top ?? 0)
        let smallHeaderHeight = event?.date == nil ? headerSmallWithoutDateHeight : headerSmallWithDateHeight
        let smallHeight = smallHeaderHeight + topMergin
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

extension EventDetailViewController {
    private func animateHeader() {
        self.headerHeightConstraint.constant = headerFullHeight
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
}
