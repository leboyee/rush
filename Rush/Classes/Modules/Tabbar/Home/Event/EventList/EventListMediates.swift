//
//  EventListMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 13/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension EventListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cell.eventType, bundle: nil), forCellReuseIdentifier: Cell.eventType)
        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
        tableView.register(UINib(nibName: Cell.eventByDate, bundle: nil), forCellReuseIdentifier: Cell.eventByDate)
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.isMyEvents == true ?  eventCategory.count + 1 : eventCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isMyEvents == true && indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventByDate, for: indexPath) as? EventByDateCell else { return UITableViewCell() }
                                          
            fillEventByDateCell(cell, indexPath)
                                           return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventType, for: indexPath) as? EventTypeCell else { return UITableViewCell() }
                                fillEventTypeCell(cell, indexPath)
                                return cell
        }
   
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.textHeader) as? TextHeader else { return UIView() }
        fillTextHeader(header, section)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightOfHeader(section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightOfFooter(section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return cellHeight(indexPath)
    }
}

// MARK: - Notification alert delegate
extension EventListViewController: NotificationAlertDelegate {
    func undoButtonClickEvent() {
        
    }
}

extension EventListViewController: UITextFieldDelegate {
    @objc func textDidChange(_ textField: UITextField) {
       
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        performSegue(withIdentifier: Segues.searchEventViewSegue, sender: nil)
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
