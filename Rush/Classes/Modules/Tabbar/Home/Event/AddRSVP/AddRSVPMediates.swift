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
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 325, right: 0)

        tableView.register(UINib(nibName: Cell.rsvpCell, bundle: nil), forCellReuseIdentifier: Cell.rsvpCell)
        
        tableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Keyboard functions
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            bottomViewContraint.constant = keyboardHeight + 10
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomViewContraint.constant = 30
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
