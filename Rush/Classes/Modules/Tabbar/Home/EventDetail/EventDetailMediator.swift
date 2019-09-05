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
        //tableView.contentInset = UIEdgeInsets(top: headerFullHeight, left: 0, bottom: 50, right: 0)
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
    
    //MARK: - Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight(section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.textHeader) as! TextHeader
        fillTextHeader(header, section)
        return header
    }
    
    //MARK: - Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return RSeparatorLine()
    }
    
    /*
    //MARK: - Scroll Delegates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let smallHeight = headerSmallHeight + (AppDelegate.getInstance().window?.safeAreaInsets.top ?? 0)
        let y = headerFullHeight - (scrollView.contentOffset.y + headerFullHeight)
        let height = min(max(y, smallHeight), screenHeight)
        self.headerHeightConstraint.constant = height
        print(height)
        
    }*/
    
}
