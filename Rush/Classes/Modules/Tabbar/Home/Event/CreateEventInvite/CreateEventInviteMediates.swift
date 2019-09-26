//
//  ContactsListMediates.swift
//  Rush
//
//  Created by ideveloper on 17/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension CreateEventInviteViewController {
    
    func setupTableView() {
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let headerNib =   UINib(nibName: ReusableView.inviteHeader, bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: ReusableView.inviteHeader)

        tableView.register(UINib(nibName: Cell.peopleCell, bundle: nil), forCellReuseIdentifier: Cell.peopleCell)
        tableView.reloadData()
    }
    
    func setupNavigation() {
        let customView = UIView(frame: CGRect(x: 24, y: 0, width: screenWidth - 72, height: 44))
        let label = UILabel(frame: CGRect(x: 0, y: 2, width: screenWidth - 72, height: 30))
        label.text = "Search people"
        label.font = UIFont.displayBold(sz: 24)
        label.textColor = UIColor.navBarTitleWhite32
        customView.addSubview(label)
        navigationItem.titleView = customView
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)

    }
}

// MARK: - Tableview methods
extension CreateEventInviteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isRushFriends == true ? items.count + 2 : items.count + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRushFriends == true {
            if section == 0 {
                return friendListAraay.count
            } else if section == 1 {
                return 0
            } else {
                return items[section - 2].contacts.count
            }
        } else {
              if section == 0 {
                return 0
            } else {
                return items[section - 1].contacts.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.peopleCell, for: indexPath) as? PeopleCell else { return UITableViewCell() }
        if isRushFriends == true {
            if indexPath.section == 0 || indexPath.section == 1 {
                let profile = friendListAraay[indexPath.row]
                cell.setup(title: "\(profile.name)")
                if let image = UIImage(named: "profile_tab_inactive") {
                    cell.setupImage(image: image)
                }
                cell.setup(isHidden: false)
                cell.setup(isSelected: selectedFriendListArray.contains(where: { $0.userId == profile.userId }))
                return cell
            } else {
                // let alpha = alphabet[indexPath.section]
                let array = items[indexPath.section - 2].contacts
                let item = array[indexPath.row]
                cell.setup(title: "\(item.displayName)")
                if let image = UIImage(named: "profile_tab_inactive") {
                    cell.setupImage(image: image)
                }
                cell.setup(isHidden: false)
                cell.setup(isSelected: selectedItem.contains(item))
                return cell
            }
        } else {
            if indexPath.section != 0 {
                // let alpha = alphabet[indexPath.section]
                let array = items[indexPath.section - 1].contacts
                let item = array[indexPath.row]
                cell.setup(title: "\(item.displayName)")
                if let image = UIImage(named: "profile_tab_inactive") {
                    cell.setupImage(image: image)
                }
                cell.setup(isHidden: false)
                cell.setup(isSelected: selectedItem.contains(item))
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isRushFriends == true {
            if section == 0 || section == 1 {
                guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.inviteHeader) as? InviteHeader else { return UIView() }
                view.headerTextLabel.text = section == 0 ? "Rush friends" : "From contacts"
                return view
            } else {
                let header = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 32))
                let label = UILabel(frame: CGRect(x: 24, y: 16, width: screenWidth, height: 16))
                let key = items[section - 2].key
                label.text = key//alphabet[section]
                label.textColor = UIColor.buttonDisableTextColor
                label.font = UIFont.semibold(sz: 13)
                header.addSubview(label)
                return header
            }
        } else {
            if section == 0 {
                guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.inviteHeader) as? InviteHeader else { return UIView() }
                view.headerTextLabel.text = "From contacts"
                return view
            } else {
                let header = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 32))
                let label = UILabel(frame: CGRect(x: 24, y: 16, width: screenWidth, height: 16))
                let key = items[section - 1].key
                label.text = key//alphabet[section]
                label.textColor = UIColor.buttonDisableTextColor
                label.font = UIFont.semibold(sz: 13)
                header.addSubview(label)
                return header
            }
        }
      
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if isRushFriends == true {
            if indexPath.section == 0 || indexPath.section == 1 {
                let profile = friendListAraay[indexPath.row]
                if  selectedFriendListArray.contains(where: { $0.userId == profile.userId}) {
                    guard let index = selectedFriendListArray.firstIndex(where: { $0.name == profile.name }) else { return }
                    selectedFriendListArray.remove(at: index)
                } else {
                    selectedFriendListArray.append(profile)
                }
            } else {
                let array = items[indexPath.section - 2].contacts
                let item = array[indexPath.row]
                if selectedItem.contains(item) {
                    guard let index = selectedItem.firstIndex(where: { $0.displayName == item.displayName }) else { return }
                    selectedItem.remove(at: index)
                } else {
                    selectedItem.append(item)
                }
            }
        } else {
            if indexPath.section != 1 {
                let array = items[indexPath.section - 1].contacts
                let item = array[indexPath.row]
                if selectedItem.contains(item) {
                    guard let index = selectedItem.firstIndex(where: { $0.displayName == item.displayName }) else { return }
                    selectedItem.remove(at: index)
                } else {
                    selectedItem.append(item)
                }
            }
        }
       
        self.tableView.reloadData()
        inviteButtonVisiable()
    }
}
