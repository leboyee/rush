//
//  HomeMediates.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit


extension MyClubViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(UINib(nibName: Cell.clubName, bundle: nil), forCellReuseIdentifier: Cell.clubName)
        
        tableView.register(UINib(nibName: Cell.clubManage, bundle: nil), forCellReuseIdentifier: Cell.clubManage)
        
        tableView.register(UINib(nibName: Cell.createUserPost, bundle: nil), forCellReuseIdentifier: Cell.createUserPost)
        
        tableView.register(UINib(nibName: Cell.tag, bundle: nil), forCellReuseIdentifier: Cell.tag)
        
        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
        
        tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
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
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.clubManage, for: indexPath) as! ClubManageCell
            
            return cell
        } else if indexPath.section == 3 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.tag, for: indexPath) as! TagCell
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.createUserPost, for: indexPath) as! CreateUserPostCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    /*
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
     
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
     return heightOfFooter(section)
      }
     
     */
    
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
