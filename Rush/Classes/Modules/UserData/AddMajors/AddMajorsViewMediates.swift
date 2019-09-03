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
            guard let index = selectedArray.firstIndex(where: { $0 == major["name"] as? String ?? ""}) else { return }
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
        let searchText = textField.text ?? ""
        getMajorList(searchText: searchText)
    }
}
