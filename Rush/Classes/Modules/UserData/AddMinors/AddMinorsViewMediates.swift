//
//  AddMinorsViewMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit


extension AddMinorsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupMediator() {
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cell.addMajorsCell, bundle: nil), forCellReuseIdentifier: Cell.addMajorsCell)
        tableView.reloadData()
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(self.textDidChanged(_:)), for: .editingChanged)

            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //MARK: - Keyboard functions
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            minorButtonConstraint.constant = keyboardHeight + 10
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        minorButtonConstraint.constant = 30

    }


    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.addMajorsCell, for: indexPath) as! AddMajorsCell
        fillAddMajorCell(cell, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let major = minorArray[indexPath.row]
        if selectedArray.contains(major["name"] as? String ?? "") {
            guard let index = selectedArray.firstIndex(where: { $0 == major["name"] as? String ?? ""}) else { return }
            selectedArray.remove(at: index)
        }
        else {
            selectedArray.append(major["name"] as? String ?? "")
        }
        self.moveToNext()

    }    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
}


extension AddMinorsViewController: UITextFieldDelegate {
    
    //MARK : UITextFieldDelegate
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
        self.minorCustomButton.isHidden = textField.text?.count ?? 0 > 0 ? false : true
        getMinorList(searchText: searchText)
    }
    
    
}
