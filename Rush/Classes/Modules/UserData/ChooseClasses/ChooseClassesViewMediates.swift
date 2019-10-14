//
//  AddMinorsViewMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ChooseClassesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupMediator() {
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cell.classesCell, bundle: nil), forCellReuseIdentifier: Cell.classesCell)
        
        tableView.register(UINib(nibName: ReusableView.classesHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.classesHeader)
        
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(self.textDidChanged(_:)), for: .editingChanged)

        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return classesArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.classesHeader) as? ClassesHeader {
            fillClassesHeader(header, section)
            return header
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightOfHeader(section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.classesCell, for: indexPath) as? ClassesCell {
            fillClassesCell(cell, indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let subClassies = subClassArray[indexPath.row]
        if selectedArray.contains(where: { $0.classId == subClassies.classId }) {
            if selectedArray.contains(where: { $0.classId == subClassies.classId && $0.id == subClassies.id }) {
                      guard let index = selectedArray.firstIndex(where: { $0.id == subClassies.id }) else { return }
                      selectedArray.remove(at: index)
                  } else {
                    guard let index = selectedArray.firstIndex(where: { $0.classId == subClassies.classId }) else { return }
                    selectedArray.remove(at: index)
                      selectedArray.append(subClassies)
                  }
        } else {
            selectedArray.append(subClassies)
        }
        selectedIndex = -1
        nextButtonVisiable()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
}

extension ChooseClassesViewController: UITextFieldDelegate {
    
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
      //  deleteButton.isHidden = textField.text?.count ?? 0 > 0 ? false : true
        let searchText = textField.text ?? ""
        pageNo = 1
        getClassListAPI(search: searchText)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count ?? 0 == 0 && string == " " {
            return false
        }
     return true
    }
}
