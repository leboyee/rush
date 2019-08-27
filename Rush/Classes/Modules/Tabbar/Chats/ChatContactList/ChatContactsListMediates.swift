//
//  ChatContactsListMediates.swift
//  Rush
//
//  Created by ideveloper on 17/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//
import UIKit

extension ChatContactsListViewController {
    
    func setupTableView() {
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cell.peopleCell, bundle: nil), forCellReuseIdentifier: Cell.peopleCell)
        tableView.reloadData()
    }
    
    func setupNavigation() {
        let customView = UIView(frame: CGRect(x: 24, y: 0, width: screenWidth - 72, height: 44))
        let label = UILabel(frame: CGRect(x: 0, y: 2, width: screenWidth - 72, height: 30))
        label.text = "Search people"
        label.font = UIFont.DisplayBold(sz: 24)
        label.textColor = UIColor.navBarTitleWhite32
        customView.addSubview(label)
        navigationItem.titleView = customView
    }
}

// MARK: - Tableview methods
extension ChatContactsListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 26
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.peopleCell, for: indexPath) as! PeopleCell
        fillCell(cell, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let alpha = alphabet[section]
        let users = friendsList[alpha.lowercased()] as? [Profile]
        if (users?.count ?? 0) > 0 {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 32))
            let label = UILabel(frame: CGRect(x: 24, y: 16, width: screenWidth, height: 16))
            label.text = alphabet[section]
            label.textColor = UIColor.buttonDisableTextColor
            label.font = UIFont.Semibold(sz: 13)
            header.addSubview(label)
            return header
        } else {
            let header = UIView()
            header.backgroundColor = .clear
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let alpha = alphabet[section]
        let users = friendsList[alpha.lowercased()] as? [Profile]
        return (users?.count ?? 0) > 0 ? 32 : CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadMoreCell(indexPath)
    }
    
}
