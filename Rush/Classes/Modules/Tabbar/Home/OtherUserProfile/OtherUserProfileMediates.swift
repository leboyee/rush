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
        tableView.register(UINib(nibName: Cell.clubManage, bundle: nil), forCellReuseIdentifier: Cell.clubManage)
        tableView.register(UINib(nibName: Cell.eventType, bundle: nil), forCellReuseIdentifier: Cell.eventType)
        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
        tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.clubManage, for: indexPath) as! ClubManageCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventType, for: indexPath) as! EventTypeCell
            fillEventCell(cell, indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = UIView()
        let separator = UIView(frame: CGRect(x: section == 0 ?  0 : 24, y: 0, width: screenWidth, height: 1))
        footer.addSubview(separator)
        separator.backgroundColor = UIColor.separatorColor
        return footer
    }
     
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightOfFooter(section)
      }
     
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.textHeader) as! TextHeader
        fillTextHeader(header, section)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightOfHeader(section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return cellHeight(indexPath)
    }
}
