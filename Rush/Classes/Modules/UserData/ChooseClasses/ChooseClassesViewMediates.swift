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

        for index in 1...5 {
            let classes = Classes()
            classes.id = index
            classes.category = "Accounting \(index)"
            for subIndex in 1...5 {
                let subClasses = SubClasses()
                subClasses.id = subIndex + (index * 10)
                subClasses.name = "\(index) Sample Data \(subIndex)"
                classes.subClasses.append(subClasses)
            }
            classesArray.append(classes)
        }
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)

        tableView.reloadData()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return classesArray.count
    }
    
  
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.classesHeader) as! ClassesHeader
        fillClassesHeader(header, section)
        return header
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.classesCell, for: indexPath) as! ClassesCell
        fillClassesCell(cell, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let classies = classesArray[indexPath.section]
        let subClassies = classies.subClasses[indexPath.row]
        self.selectedArray["\(indexPath.section)"] = subClassies
        selectedIndex = -1
        moveToNext()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
}


