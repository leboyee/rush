//
//  ContactsListMediates.swift
//  Rush
//
//  Created by ideveloper on 17/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ContactsListViewController {
    
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
        label.text = isFromRegister == true ? Text.inviteFromContact : "Search people"
        label.font = UIFont.displayBold(sz: 24)
        label.textColor = UIColor.navBarTitleWhite32
        customView.addSubview(label)
        navigationItem.titleView = customView
        
        if isFromRegister == true {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
            
        }
    }
}

// MARK: - Tableview methods
extension ContactsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items[section].contacts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.peopleCell, for: indexPath) as? PeopleCell else { return UITableViewCell() }
        // let alpha = alphabet[indexPath.section]
        let array = items[indexPath.section].contacts
        let item = array[indexPath.row]
        cell.setup(title: "\(item.displayName)")
        cell.setupImage(image: UIImage(named: "profile_tab_inactive")!)
        cell.setup(isHidden: !isFromRegister)
        cell.setup(isSelected: selectedItem.contains(item))
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 32))
        let label = UILabel(frame: CGRect(x: 24, y: 16, width: screenWidth, height: 16))
        let key = items[section].key
        label.text = key//alphabet[section]
        label.textColor = UIColor.buttonDisableTextColor
        label.font = UIFont.semibold(sz: 13)
        header.addSubview(label)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromRegister == true {
            let array = items[indexPath.section].contacts
            let item = array[indexPath.row]
            if selectedItem.contains(item) {
                guard let index = selectedItem.firstIndex(where: { $0.displayName == item.displayName }) else { return }
                selectedItem.remove(at: index)
            } else {
                selectedItem.append(item)
            }
            self.tableView.reloadData()
            inviteButtonVisiable()
        } else {
            let controller = ChatRoomViewController()
            controller.isGroupChat = false
            controller.chatDetailType = .single
            controller.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
}
