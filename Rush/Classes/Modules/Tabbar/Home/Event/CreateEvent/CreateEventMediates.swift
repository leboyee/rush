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
        } else if indexPath.section == 4 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.dateAndTimeEvent, for: indexPath) as? DateAndTimeCell {
                fillDateAndTimeEvent(cell, indexPath)
                return cell
            }
        } else if indexPath.section == 5 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.dateAndTimeEvent, for: indexPath) as? DateAndTimeCell {
                fillDateAndTimeEvent(cell, indexPath)
                return cell
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            if let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.userImagesHeader) as? UserImagesHeaderView {
                fillImageHeader(view)
                return view
            }
        }
        return nil
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
    
    /*
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.textHeader) as! TextHeader
        fillTextHeader(header, section)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightOfHeader(section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightOfFooter(section)
    }
    */
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return cellHeight(indexPath)
    }
}

// MARK: - Scrollview delegate
extension CreateEventViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let headerView = tableView?.tableHeaderView {
            let yPos: CGFloat = (scrollView.contentOffset.y + scrollView.adjustedContentInset.top)
            let heigh: CGFloat = 346
            if yPos >= 0 {
                var rect = headerView.frame
                rect.origin.y = scrollView.contentOffset.y
                rect.size.height = heigh - yPos
                headerView.frame = rect
                tableView?.tableHeaderView = headerView
            }
        } else {
            if tableView.contentOffset.y >= 190 {
                
            } else {
                
                let animation = CATransition()
                animation.duration = 0.8
                animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
                animation.type = CATransitionType.fade
                
                navigationController?.navigationBar.layer.add(animation, forKey: nil)
            }
            
            if tableView.contentOffset.y < -40 {
                tableView.contentOffset = CGPoint(x: 0, y: -40)
            }
        }
    }
}

// MARK: - SelectEventTypeController Delegate
extension CreateEventViewController: SelectEventTypeDelegate {
    func createEventClub(_ type: EventType, _ screenType: ScreenType) {

    }
    
    func addPhotoEvent(_ type: PhotoFrom) {
        if type == .cameraRoll {
            self.openCameraOrLibrary(type: .photoLibrary)
        } else {
            Utils.alert(message: "In Development")
        }
    }
}
