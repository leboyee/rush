//
//  CreateEventMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//
import UIKit

extension AddLocationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 55
        tableView.rowHeight = UITableView.automaticDimension
                
        tableView.register(UINib(nibName: Cell.addEventLocationCell, bundle: nil), forCellReuseIdentifier: Cell.addEventLocationCell)
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.addEventLocationCell, for: indexPath) as? AddEventLocationCell {
            fillLocationCell(cell, indexPath)
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
        
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return cellHeight(indexPath)
    }
}

// MARK: - UITextField delegate
extension AddLocationViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Search for locations for user's entry & reload table.
        
        
    }
}
