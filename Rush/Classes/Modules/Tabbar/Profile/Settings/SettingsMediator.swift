//
//  SettingsMediator.swift
//  Rush
//
//  Created by kamal on 08/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension SettingsViewController {
    
    func setupTableView() {
        
        tableView.layer.cornerRadius = topViewRadius
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 88.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: Cell.settingsInfo, bundle: nil), forCellReuseIdentifier: Cell.settingsInfo)
        tableView.register(UINib(nibName: Cell.switchCell, bundle: nil), forCellReuseIdentifier: Cell.switchCell)
        tableView.register(UINib(nibName: Cell.instagram, bundle: nil), forCellReuseIdentifier: Cell.instagram)

        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
        tableView.reloadData()
    }
    
    
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.instagram, for: indexPath) as! InstagramCell
            fillInstagramCell(cell, indexPath)
            return cell
        } else if indexPath.section == 1, indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.switchCell, for: indexPath) as! SwitchCell
            fillSwitchCell(cell, indexPath)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.settingsInfo, for: indexPath) as! SettingsInfoCell
            fillCell(cell, indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow(indexPath)
    }
    
    //MARK: - Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight(section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.textHeader) as! TextHeader
        fillTextHeader(header, section)
        return header
    }
    
    //MARK: - Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

