//
//  CreateEventInterestViewMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
extension CreateEventInterestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupMediator() {
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cell.chooseTagCell, bundle: nil), forCellReuseIdentifier: Cell.chooseTagCell)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)

        let headerNib =   UINib(nibName: ReusableView.inviteHeader, bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: ReusableView.inviteHeader)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let interest = Authorization.shared.profile?.interest
        return isSearch == true ? 1 : interest?.count ?? 0 > 0 ? interestArray.count > 0 ? 2 : 1 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.chooseTagCell, for: indexPath) as? ChooseTagCell {
            fillTagCell(cell, indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.inviteHeader) as? InviteHeader else { return UIView() }
        view.headerTextLabel.text = isSearch == true ? "Explore interests:" :  Authorization.shared.profile?.interest?.count ?? 0 > 0 ? section == 0 ? "My interests" : "All interests" : "All interests"
        view.headerTextLabel.textColor = isSearch == true ? UIColor.brown24 : UIColor.bgBlack
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }

}

extension CreateEventInterestViewController: UITextFieldDelegate {
    @objc func textDidChange(_ textField: UITextField) {
        let searchText = textField.text ?? ""
        self.isSearch = searchText.count > 0 ? true : false
        getInterestList(search: textField.text ?? "")
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
