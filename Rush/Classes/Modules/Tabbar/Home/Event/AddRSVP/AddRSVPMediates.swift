//
//  CreateEventMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//
import UIKit

extension AddRSVPViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
                
        tableView.register(UINib(nibName: Cell.rsvpCell, bundle: nil), forCellReuseIdentifier: Cell.rsvpCell)
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.rsvpCell, for: indexPath) as? RSVPCell {
            fillRsvpCell(cell, indexPath)
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

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
extension AddRSVPViewController: UIScrollViewDelegate {
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

