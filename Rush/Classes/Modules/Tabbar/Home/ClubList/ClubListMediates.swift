//
//  ClubListMediates.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ClubListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        tableView.register(UINib(nibName: Cell.eventType, bundle: nil), forCellReuseIdentifier: Cell.eventType)
        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
        tableView.register(UINib(nibName: Cell.friendClub, bundle: nil), forCellReuseIdentifier: Cell.friendClub)
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if screenType == .club {
            return clubInterestList.count + 1
        } else {
            return classesList.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if screenType == .club && indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.friendClub, for: indexPath) as? FriendClubCell else { return UITableViewCell() }
            fillMyClubCell(cell, indexPath)
            return cell
        } else if screenType == .classes && indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.friendClub, for: indexPath) as? FriendClubCell else { return UITableViewCell() }
            fillMyClubCell(cell, indexPath)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventType, for: indexPath) as? EventTypeCell else { return UITableViewCell() }
            fillEventTypeCell(cell, indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected(indexPath)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadMoreCell(indexPath)
    }
}

// MARK: - SelectEventTypeController Delegate
extension ClubListViewController: SelectEventTypeDelegate {
    func createEventClub(_ type: EventType, _ screenType: ScreenType) {
        openCreateClubViewController()
    }
    
    func addPhotoEvent(_ type: PhotoFrom) {
        
    }
}

// MARK: - CreatePostViewController Delegate
extension ClubListViewController: CreatePostViewControllerDelegate {
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
//                                    Utils.notReadyAlert()
        })
        snackbar.show()
    }
}

// MARK: - Notification alert delegate
extension ClubListViewController: NotificationAlertDelegate {
    func undoButtonClickEvent() {
        
    }
}

// MARK: - ClubDetailProtocol delegate
extension ClubListViewController: ClubDetailProtocol {
    func deleteClubSuccess(_ club: Club?) {
        let snackbar = TTGSnackbar(message: "\(club?.clubName ?? "") is deleted.",
            duration: .middle,
            actionText: "",
            actionBlock: { (_) in })
        snackbar.show()
    }
}

// MARK: - SeachField delegate
extension ClubListViewController: UITextFieldDelegate {
    @objc func textDidChange(_ textField: UITextField) {
        searchText = textField.text ?? ""
        pageNoM = 1
        pageNoO = 1
        isNextPageO = false
        isNextPageM = false
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(callAPI), object: nil)
        self.perform(#selector(callAPI), with: nil, afterDelay: 0.5)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func callAPI() {
        if screenType == .club {
            getMyClubListAPI(sortBy: "my")
            getClubCategoryListAPI()
        } else {
            getMyJoinedClasses(search: searchText)
            getClassCategoryAPI()
        }
    }
}
