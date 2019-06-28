//
//  AddMinorsViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ChooseClassesViewController {
    
    
    func heightOfHeader(_ section: Int) -> CGFloat {
        return 56
    }
    

    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
            return 56
    }
    
    func cellCount(_ section: Int) -> Int {
        if selectedIndex == section {
            let classies = classesArray[selectedIndex]
            return classies.subClasses.count
        }
        else {
            return 0
        }
       
    }
    
    func fillClassesCell(_ cell: ClassesCell, _ indexPath: IndexPath) {
        let classies = classesArray[indexPath.section]
        let subclassies = classies.subClasses[indexPath.row]
        cell.titleLabel.text = subclassies.name
    }
    
    func fillClassesHeader(_ header: ClassesHeader, _ section: Int) {
        let classies = classesArray[section]
        let subClassies = classies.subClasses
        for subClassObj in subClassies {
            if selectedArray.contains(subClassObj) {
                header.setup(detailsLableText: subClassObj.name)
            }
        }
        header.titleLabel.text = classies.category
        header.headerButton.tag = section
        header.headerButton.addTarget(self, action: #selector(headerSelectionAction), for: .touchUpInside)
        header.arrowImageView.isHighlighted = section == selectedIndex ? true : false
    }
    
    @objc func headerSelectionAction(_ sender: UIButton) {
        if selectedIndex == sender.tag {
            selectedIndex = -1
        }
        else {
            selectedIndex = sender.tag
        }
        tableView.reloadData()
    }

}

//MARK: - Manage Interator or API's Calling
extension ChooseClassesViewController {
    
}
