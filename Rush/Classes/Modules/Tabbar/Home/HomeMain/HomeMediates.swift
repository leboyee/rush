//
//  HomeMediates.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cell.tutorialPopUp, bundle: nil), forCellReuseIdentifier: Cell.tutorialPopUp)
        tableView.register(UINib(nibName: Cell.eventType, bundle: nil), forCellReuseIdentifier: Cell.eventType)
        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
        tableView.register(UINib(nibName: Cell.eventByDate, bundle: nil), forCellReuseIdentifier: Cell.eventByDate)
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            if isShowTutorial {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.tutorialPopUp, for: indexPath) as? TutorialPopUpCell else { return UITableViewCell() }
                    fillTutorialCell(cell)
                    return cell
            } else {
                return UITableViewCell()
            }
        } else {
            if isShowJoinEvents && indexPath.section == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventByDate, for: indexPath) as? EventByDateCell else { return UITableViewCell() }
                fillEventByDateCell(cell, indexPath)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventType, for: indexPath) as? EventTypeCell else { return UITableViewCell() }
                fillEventTypeCell(cell, indexPath)
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.textHeader) as? TextHeader else { return UIView() }
        fillTextHeader(header, section)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightOfHeader(section)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightOfFooter(section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return cellHeight(indexPath)
    }
}

// MARK: - SelectEventTypeController Delegate
extension HomeViewController: SelectEventTypeDelegate {
    func createEventClub(_ type: EventType, _ screenType: ScreenType) {
        /*
         screenType: club, event
         type: public, closed, invite only
        */
        
        if screenType == .club { // Open club detail
            performSegue(withIdentifier: Segues.createClub, sender: nil)
        } else if screenType == .event { // Open event detail
            performSegue(withIdentifier: Segues.createEvent, sender: type)
        }
    }

    func addPhotoEvent(_ type: PhotoFrom) {
        
    }
}

// MARK: - CreatePostViewController Delegate
extension HomeViewController: CreatePostViewControllerDelegate {
    func createPostSuccess(_ post: Post) {
    }
    
    func showSnackBar(text: String, buttonText: String) {
        /*
        notificationTitle = text
        notificationButtonTitle = buttonText
        performSegue(withIdentifier: Segues.notificationAlert, sender: nil)
        */
        let snackbar = TTGSnackbar(message: text,
                                   duration: .middle,
                                   actionText: buttonText,
                                   actionBlock: { (_) in
                                    Utils.notReadyAlert()
        })
        snackbar.show()
    }
}

// MARK: - Notification alert delegate
extension HomeViewController: NotificationAlertDelegate {
    func undoButtonClickEvent() {
        
    }
}
