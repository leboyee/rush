//
//  CreateEventMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//
import UIKit

extension CreateEventViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        
        let headerNib =   UINib(nibName: ReusableView.userImagesHeader, bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: ReusableView.userImagesHeader)
        
        tableView.register(UINib(nibName: Cell.textIcon, bundle: nil), forCellReuseIdentifier: Cell.textIcon)
        
        tableView.register(UINib(nibName: Cell.textView, bundle: nil), forCellReuseIdentifier: Cell.textView)
        
        tableView.register(UINib(nibName: Cell.dateAndTimeEvent, bundle: nil), forCellReuseIdentifier: Cell.dateAndTimeEvent)
        
          tableView.register(UINib(nibName: Cell.addEventCalendarCell, bundle: nil), forCellReuseIdentifier: Cell.addEventCalendarCell)
        
        tableView.register(UINib(nibName: Cell.eventTimeCell, bundle: nil), forCellReuseIdentifier: Cell.eventTimeCell)
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 8 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.textIcon, for: indexPath) as? TextIconCell {
                fillTextIconCell(cell, indexPath)
                return cell
            }
        } else if indexPath.section == 4 || indexPath.section == 5 {
            if indexPath.row == 0 {
                if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.dateAndTimeEvent, for: indexPath) as? DateAndTimeCell {
                    fillDateAndTimeEvent(cell, indexPath)
                    return cell
                }
            } else {
                if isStartDate == true || isEndDate == true {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.addEventCalendarCell, for: indexPath) as? AddEventCalendarCell {
                        fillAddCalendarCell(cell, indexPath)
                        return cell
                    }
                } else if isStartTime == true || isEndTime == true {
                    if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventTimeCell, for: indexPath) as? EventTimeCell {
                        fillEventTimeCell(cell, indexPath)
                        return cell
                    }

                } else {
                   return UITableViewCell()
                }
               
            }
         
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.textView, for: indexPath) as? TextViewCell {
                fillTextViewCell(cell, indexPath)
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCell(indexPath)
    }
        
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightOfHeader(section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return cellHeight(indexPath)
    }
}

// MARK: - Scrollview delegate
extension CreateEventViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if eventImage != nil || clubHeader.userImageView.image != nil {
            let topMergin = (AppDelegate.shared?.window?.safeAreaInsets.top ?? 0)
            let smallHeaderHeight = headerSmallWithoutDateHeight
            let smallHeight = smallHeaderHeight + topMergin
            let h = heightConstraintOfHeader.constant - scrollView.contentOffset.y
            let height = min(max(h, smallHeight), screenHeight)
            self.heightConstraintOfHeader.constant = height
            if !smallHeight.isEqual(to: height) {
                tableView.contentOffset = CGPoint(x: 0, y: 0)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.heightConstraintOfHeader.constant > headerFullHeight {
            animateHeader()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.heightConstraintOfHeader.constant > headerFullHeight {
            animateHeader()
        }
    }
    
    private func animateHeader() {
        self.heightConstraintOfHeader.constant = headerFullHeight
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
