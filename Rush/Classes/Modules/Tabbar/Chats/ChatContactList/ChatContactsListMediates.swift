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
        // Set left bar button and title
        let customView = UIView(frame: CGRect(x: 45, y: 0, width: screenWidth - 45, height: 44))
        
        let searchTextField = UITextField(frame: CGRect(x: -5, y: -3, width: screenWidth - 45, height: 44))
        searchTextField.font = UIFont.displayBold(sz: 24)
        searchTextField.textColor = UIColor.white
        searchTextField.returnKeyType = .go
        searchTextField.autocorrectionType = .no
        searchTextField.delegate = self
        let font = UIFont.displayBold(sz: 24)
        let color = UIColor.navBarTitleWhite32
        searchTextField.attributedPlaceholder = NSAttributedString(string: "Search people", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color])
        searchTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        customView.addSubview(searchTextField)
        navigationItem.titleView = customView
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        
    }
}

// MARK: - Tableview methods
extension ChatContactsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 26
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.peopleCell, for: indexPath) as? PeopleCell {
            fillCell(cell, indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let alpha = alphabet[section]
        let users = friendsList[alpha.lowercased()] as? [Friend]
        if (users?.count ?? 0) > 0 {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 32))
            let label = UILabel(frame: CGRect(x: 24, y: 16, width: screenWidth, height: 16))
            label.text = alphabet[section]
            label.textColor = UIColor.buttonDisableTextColor
            label.font = UIFont.semibold(sz: 13)
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
        let users = friendsList[alpha.lowercased()] as? [Friend]
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

extension ChatContactsListViewController: UITextFieldDelegate {
    @objc func textDidChange(_ textField: UITextField) {
        searchText = textField.text ?? ""
        pageNo = 1
        isNextPageExist = false
        getFriendListAPI()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
