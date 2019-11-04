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
        let customView = UIView(frame: CGRect(x: 48, y: 0, width: screenWidth - 48, height: 44))
            searchTextFiled = UITextField(frame: CGRect(x: 0, y: -3, width: screenWidth - 48, height: 44))
            searchTextFiled?.font = UIFont.displayBold(sz: 24)
            searchTextFiled?.textColor = UIColor.white
            searchTextFiled?.returnKeyType = .go
            searchTextFiled?.autocorrectionType = .no
            searchTextFiled?.delegate = self
            let font = UIFont.displayBold(sz: 24)
            let color = UIColor.navBarTitleWhite32
        searchTextFiled?.attributedPlaceholder = NSAttributedString(string: isFromUserProfile == true ? "Find in contacts" : "Search friends", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
            searchTextFiled?.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        customView.addSubview(searchTextFiled ?? UITextField())
            navigationItem.titleView = customView
            self.view.backgroundColor = UIColor.bgBlack

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
       
    }
}

// MARK: - Tableview methods
extension ContactsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearch == true ? searchItem.count : items.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearch == true ? searchItem[section].contacts.count : items[section].contacts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.peopleCell, for: indexPath) as? PeopleCell else { return UITableViewCell() }
        // let alpha = alphabet[indexPath.section]
        let array =  isSearch == true ? searchItem[indexPath.section].contacts : items[indexPath.section].contacts
        let item = array[indexPath.row]
        cell.setup(title: "\(item.displayName)")
        cell.setupImage(image: item.contactImage ?? UIImage(named: "iconProfilePlaceHolder")!)
        cell.setup(isHidden: false)
        cell.setup(isSelected: selectedItem.contains(item))
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 32))
        let label = UILabel(frame: CGRect(x: 24, y: 16, width: screenWidth, height: 16))
        let key = isSearch == true ? searchItem[section].key : items[section].key
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
        let array = isSearch == true ? searchItem[indexPath.section].contacts :  items[indexPath.section].contacts
            let item = array[indexPath.row]
            if selectedItem.contains(item) {
                guard let index = selectedItem.firstIndex(where: { $0.displayName == item.displayName }) else { return }
                selectedItem.remove(at: index)
            } else {
                selectedItem.append(item)
            }
            self.tableView.reloadData()
            inviteButtonVisiable()
        
    }
    
}

extension ContactsListViewController: UITextFieldDelegate {
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
