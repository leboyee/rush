//
//  HomeMediates.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        searchView.layer.cornerRadius = 24
        searchView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: Cell.eventType, bundle: nil), forCellReuseIdentifier: Cell.eventType)
        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
        tableView.register(UINib(nibName: Cell.exploreCell, bundle: nil), forCellReuseIdentifier: Cell.exploreCell)
        tableView.register(UINib(nibName: Cell.searchClubCell, bundle: nil), forCellReuseIdentifier: Cell.searchClubCell)
        tableView.register(UINib(nibName: Cell.peopleCell, bundle: nil), forCellReuseIdentifier: Cell.peopleCell)
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return isSearch ? 1 : 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSearch {
            if searchType != .people {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.searchClubCell, for: indexPath) as? SearchClubCell else { return UITableViewCell() }
                fillEventCell(cell, indexPath)
                return cell
            } else if searchType == .people {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.peopleCell, for: indexPath) as? PeopleCell else { return UITableViewCell() }
                fillPeopleCell(cell, indexPath)
                return cell
            } else {
                return UITableViewCell()
            }
        } else {
            if indexPath.section == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.exploreCell, for: indexPath) as? ExploreCell else { return UITableViewCell() }
                fillExploreCell(cell, indexPath)
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventType, for: indexPath) as? EventTypeCell else { return UITableViewCell() }
                fillEventTypeCell(cell, indexPath)
                return cell
            }
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
        willDisplay(indexPath)
    }
}

// MARK: - Textfield Delegate
extension ExploreViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isSearch = true
        heightConstraintOfFilter.constant = 67
        // C*
        getEventCategoryListAPI()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
       // isSearch = false
        //heightConstraintOfFilter.constant = 0
      //  textField.text = ""
      //  clearButton.isHidden = true
        tableView.reloadData()
        return true
    }
    
    @objc func textFieldDidChanged(_ textField: UITextField) {
        if (textField.text ?? "").count > 0 {
            searchText = textField.text ?? ""
            clearButton.isHidden = false
        } else {
            searchText = ""
            clearButton.isHidden = true
        }
        if searchType == .event {
            eventInterestList.removeAll()
            eventCatPageNo = 1
            isEventCatIsNextPageExist = true
            getEventCategoryListAPI()
        } else if searchType == .club {
            clubInterestList.removeAll()
            clubCatPageNo = 1
            isClubCatIsNextPageExist = true
            getClubCategoryListAPI()
        } else if searchType == .classes {
            classCategoryList.removeAll()
            classCatPageNo = 1
            isClassCatIsNextPageExist = true
            getClassCategoryAPI()
        } else if searchType == .people {
            peopleList.removeAll()
            pageNo = 1
            isNextPageExist = true
            getPeopleListAPI()
        }
    }
}

// MARK: - SelectEventTypeController Delegate
extension ExploreViewController: SelectEventTypeDelegate {
    func createEventClub(_ type: EventType, _ screenType: ScreenType) {
        performSegue(withIdentifier: Segues.createClub, sender: nil)
    }
    
    func addPhotoEvent(_ type: PhotoFrom) {
        
    }
}

// MARK: - CreatePostViewController Delegate
extension ExploreViewController: CreatePostViewControllerDelegate {
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
// MARK: - OtherUserProfile delegate
extension ExploreViewController: OtherUserProfileProtocol {
    func unfriendUser(_ name: String) {
        let snackbar = TTGSnackbar(message: "You unfriended \(name)",
            duration: .middle,
            actionText: "",
            actionBlock: { (_) in
        })
        snackbar.show()
    }
}

// MARK: - Notification alert delegate
extension ExploreViewController: NotificationAlertDelegate {
    func undoButtonClickEvent() {
        
    }
}
// MARK: - University delegate
extension ExploreViewController: UniversityViewControllerDelegate {
    func setSelectedUniversity(university: University) {
        selUniversity = university
        var uname = ""
        if selUniversity.universityName != "" {
             uname = selUniversity.universityName
        } else {
            uname = Authorization.shared.profile?.university?.first?.universityName ?? ""
        }
        universityButton.setTitle(uname, for: .normal)
    }
}
