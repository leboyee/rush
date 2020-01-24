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
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        
        let headerNib =   UINib(nibName: ReusableView.inviteHeader, bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: ReusableView.inviteHeader)

        tableView.register(UINib(nibName: Cell.peopleCell, bundle: nil), forCellReuseIdentifier: Cell.peopleCell)
        tableView.reloadData()
    }
    
    func setupNavigation() {
        let customView = UIView(frame: CGRect(x: 48, y: 0, width: screenWidth - 48, height: 44))
                  searchTextFiled = UITextField(frame: CGRect(x: 0, y: -3, width: screenWidth - 48, height: 44))
                  searchTextFiled?.font = UIFont.displayBold(sz: 24)
                  searchTextFiled?.textColor = UIColor.white
                  searchTextFiled?.returnKeyType = .go
                  searchTextFiled?.autocorrectionType = .no
                  searchTextFiled?.delegate = self
                  let font = UIFont.displayBold(sz: 24)
                  let color = UIColor.navBarTitleWhite32
                  searchTextFiled?.attributedPlaceholder = NSAttributedString(string: "Search people", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
                  searchTextFiled?.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
              customView.addSubview(searchTextFiled ?? UITextField())
                  navigationItem.titleView = customView
                  self.view.backgroundColor = UIColor.bgBlack

              self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
              tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)

    }
}

// MARK: - Tableview methods
extension CreateEventInviteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isRushFriends == true {
            return isSearch == true ? searchItem.count + 2 : items.count + 2
        } else {
           return isSearch == true ? searchItem.count + 1 : items.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRushFriends == true {
            if section == 0 {
                return friendListAraay.count
            } else if section == 1 {
                return 0
            } else {
                return isSearch == true ? searchItem[section - 2].contacts.count : items[section - 2].contacts.count
            }
        } else {
              if section == 0 {
                return 0
            } else {
                return isSearch == true ? searchItem[section - 1].contacts.count : items[section - 1].contacts.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.peopleCell, for: indexPath) as? PeopleCell else { return UITableViewCell() }
        if isRushFriends == true {
            if indexPath.section == 0 || indexPath.section == 1 {
                let profile = friendListAraay[indexPath.row]
                cell.setup(title: "\(profile.name)")
                if let imageName = profile.photo {
                    cell.setup(url: URL(string: imageName.thumb))
                }
                cell.setup(isHidden: false)
                cell.setup(isSelected: selectedFriendListArray.contains(where: { $0.userId == profile.userId }))
                return cell
            } else {
                // let alpha = alphabet[indexPath.section]
                let array = isSearch == true ? searchItem[indexPath.section - 2].contacts : items[indexPath.section - 2].contacts
                let item = array[indexPath.row]
                cell.setup(title: "\(item.displayName)")
                cell.setupImage(image: #imageLiteral(resourceName: "placeholder-profile-32px"))
                cell.setup(isHidden: false)
                cell.setup(isSelected: selectedItem.contains(where: { $0.displayName == item.displayName }))
                return cell
            }
        } else {
            if indexPath.section != 0 {
                // let alpha = alphabet[indexPath.section]
                let array = isSearch == true ? searchItem[indexPath.section - 1].contacts : items[indexPath.section - 1].contacts
                let item = array[indexPath.row]
                cell.setup(title: "\(item.displayName)")
                if let image = UIImage(named: "iconProfilePlaceHolder") {
                    cell.setupImage(image: image)
                }
                cell.setup(isHidden: false)
                cell.setup(isSelected: selectedItem.contains(where: { $0.displayName == item.displayName }))
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
                let key = isSearch == true ? searchItem[section - 2].key : items[section - 2].key
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
                let key = isSearch == true ? searchItem[section - 1].key : items[section - 1].key
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
                if  selectedFriendListArray.contains(where: { $0.userId == profile.userId }) {
                    guard let index = selectedFriendListArray.firstIndex(where: { $0.name == profile.name }) else { return }
                    selectedFriendListArray.remove(at: index)
                } else {
                    selectedFriendListArray.append(profile)
                }
            } else {
                let array = isSearch == true ? searchItem[indexPath.section - 2].contacts : items[indexPath.section - 2].contacts
                let item = array[indexPath.row]
                if selectedItem.contains(item) {
                    guard let index = selectedItem.firstIndex(where: { $0.displayName == item.displayName }) else { return }
                    selectedItem.remove(at: index)
                } else {
                    selectedItem.append(item)
                }
            }
        } else {
            if indexPath.section != 0 {
                let array = isSearch == true ? searchItem[indexPath.section - 1].contacts : items[indexPath.section - 1].contacts
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

extension CreateEventInviteViewController: UITextFieldDelegate {
    @objc func textDidChange(_ textField: UITextField) {
     
        searchItem.removeAll()
        var newItemDicts = [String: [Contact]]()
        if textField.text?.count ?? 0 > 0 {
            isSearch = true
            let searchText = textField.text ?? ""
            for newItem in items {
                let filterData = newItem.contacts.filter { $0.displayName.contains(searchText) }
                if filterData.count > 0 {
                    newItemDicts[newItem.key] = filterData
                }
            }
            searchItem = newItemDicts.map { (key, value) -> ContactsPresenterItem in
                return (key, value)
            }.sorted(by: {
                return $0.key < $1.key
            })
        } else {
            isSearch = false
        }
        
        if textField.text?.count ?? 0 > 0 {
            pageNo = 1
            searchText = textField.text ?? ""
            getFriendListAPI()
        } else {
            pageNo = 1
            searchText = ""
            getFriendListAPI()
        }
        
        self.tableView.reloadData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
