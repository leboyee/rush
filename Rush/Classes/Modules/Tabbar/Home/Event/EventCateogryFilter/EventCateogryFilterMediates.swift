//
//  EventCateogryFilterMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 28/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//
import UIKit
import PanModal

extension EventCateogryFilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        
        tableView.register(UINib(nibName: Cell.eventCategoryFilterCell, bundle: nil), forCellReuseIdentifier: Cell.eventCategoryFilterCell)
        tableView.register(UINib(nibName: ReusableView.eventCategoryFilterHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.eventCategoryFilterHeader)
        tableView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventCategoryFilterCell, for: indexPath) as? EventCategoryFilterCell else { return UITableViewCell() }
            fillCell(cell, indexPath)
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.eventCategoryFilterHeader) as? EventCategoryFilterHeader else { return UIView() }
            fillTextHeader(header, section)
            return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return cellHeight(indexPath)
    }
}
