//
//  ClubListMediates.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit


extension SearchClubViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cell.searchClubCell, bundle: nil), forCellReuseIdentifier: Cell.searchClubCell)
        tableView.register(UINib(nibName: Cell.friendClub, bundle: nil), forCellReuseIdentifier: Cell.friendClub)
        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if searchType == .searchList || searchType == .classes {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.searchClubCell, for: indexPath) as! SearchClubCell
            fillCell(cell, indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.friendClub, for: indexPath) as! FriendClubCell
            fillMyClubCell(cell, indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if searchType == .searchList {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.textHeader) as! TextHeader
            fillTextHeader(header, section)
            return header
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return searchType == .searchList ? 50 : CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return cellHeight(indexPath)
    }
}
