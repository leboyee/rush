//
//  EditProfileMediator.swift
//  Rush
//
//  Created by Suresh Jagnani on 04/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//
import UIKit

extension EditProfileViewController {
   
    func setupTableView() {
        tableView.layer.cornerRadius = topViewRadius
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 150.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(cellName: Cell.editProfileImage)
        tableView.register(cellName: Cell.editProfileInfo)
        tableView.register(cellName: Cell.editProfileMinorCell)
        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        tableView.reloadData()
    }
    
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: Cell.editProfileImage,
                for: indexPath) as? EditProfileImageCell {
                fillProfileImageCell(cell, indexPath)
                return cell
            }
        } else if indexPath.section == 1 || indexPath.section == 2 {
            if let cell = tableView.dequeueReusableCell(
                withIdentifier: Cell.editProfileInfo,
                for: indexPath) as? EditProfileInfoCell {
                fillProfileInfoCell(cell, indexPath)
                return cell
            }
        } else if indexPath.section == 3 ||  indexPath.section == 4 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.editProfileMinorCell, for: indexPath) as? EditProfileMinorCell else { return UITableViewCell() }
                    fillProfileMajorCell(cell, indexPath)
                    return cell
        }
         return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow(indexPath)
    }
    
    // MARK: - Header
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.textHeader) as? TextHeader {
            fillTextHeader(header, section)
            return header
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
         return sectionHeight(section)
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
           header.setup(isDetailArrowHide: true)
           switch section {
           case 1:
               header.setup(title: Text.personal)
           case 2:
               header.setup(title: Text.education)
            case 3:
                header.setup(title: Text.majors)
            case 4:
                header.setup(title: Text.minors)
           default:
               header.setup(title: "")
           }
       }
    
    // MARK: - Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
