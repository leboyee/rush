//
//  AddMajorsViewMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension AddMajorsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupMediator() {
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cell.addMajorsCell, bundle: nil), forCellReuseIdentifier: Cell.addMajorsCell)
        tableView.reloadData()
        searchTextField.addTarget(self, action: #selector(self.textDidChanged(_:)), for: .editingChanged)

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.addMajorsCell, for: indexPath) as? AddMajorsCell {
            fillAddMajorCell(cell, indexPath)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let major = majorArray[indexPath.row]

        if selectedArray.contains(major["name"] as? String ?? "") {
            guard let index = selectedArray.firstIndex(where: { $0 == major["name"] as? String ?? "" }) else { return }
            selectedArray.remove(at: index)
        } else {
            selectedArray.append(major["name"] as? String ?? "")
        }
        self.moveToNext()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
}

extension AddMajorsViewController: UITextFieldDelegate {
    
    // MARK: - UITextFieldDelegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    @objc func textDidChanged(_ textField: UITextField) {
        deleteButton.isHidden = textField.text?.count ?? 0 > 0 ? false : true
        let searchText = textField.text ?? ""
        getMajorList(searchText: searchText)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" { return true } else if textField.text?.count ?? 0 == 0 && string == " " {
            return false
        }
        let maxLength = 50
        let currentString: NSString = textField.text as NSString? ?? ""
        var newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if string.count >= maxLength {
            newString = String(string.prefix(maxLength)) as NSString
            textField.text = newString as String
            deleteButton.isHidden = textField.text?.count ?? 0 > 0 ? false : true
            let searchText = textField.text ?? ""
            getMajorList(searchText: searchText)
            return false
        }
        return  textField.text?.count ?? 0 < maxLength
    }

}
