//
//  ContactsListLogics.swift
//  Rush
//
//  Created by ideveloper on 17/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension CreateEventInviteViewController {
    
    func getContacts() {
        ContactsManager().getUserContactPermission { [weak self] (success, error) in
            guard let unself = self else { return }
            Utils.showSpinner()
            if success {
                ContactsManager().getUserContacts { [weak self] (contacts, success, error) in
                    guard let unself = self else { return }
                    DispatchQueue.main.async {
                        if success {
                            for contact in contacts {
                                var sectionKey = ""
                                guard let firstLetter = contact.displayName.first else { continue }
                                let firstLetterString = String(firstLetter).capitalized
                                sectionKey = firstLetterString
                                if unself.itemsDictionary[sectionKey] == nil {
                                    unself.itemsDictionary[sectionKey] = [Contact]()
                                }
                                if var models = unself.itemsDictionary[sectionKey] {
                                    models.append(contact)
                                    unself.itemsDictionary[sectionKey] = models
                                }
                            }
                            
                            unself.items = unself.itemsDictionary.map { (key, value) -> ContactsPresenterItem in
                                return (key, value)
                                }.sorted(by: {
                                    return $0.key < $1.key
                                })
                            Utils.hideSpinner()
                            unself.tableView.reloadData()
                        } else {
                            Utils.hideSpinner()
                            Utils.alert(message: error)
                        }
                        unself.tableView.reloadData()
                    }
                    
                }
            } else {
                Utils.hideSpinner()
             let message = "This app requires access to Contacts to proceed. Would you like to open settings and grant permission to contacts?."
                unself.alertContactAccess(message: message)
            }
        }
    }
    
    func alertContactAccess(message: String) {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        let alert = UIAlertController(
            title: "Contact Access",
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(
            UIAlertAction(
                title: "Settings",
                style: .cancel,
                handler: { (_) -> Void in
                    UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
            }))
        alert.show()
    }
}

// MARK: - Services
extension CreateEventInviteViewController {
    func getFriendListAPI() {
        
        if pageNo == 1 { friendsList.removeAll() }
        
        var params = [Keys.pageNo: "\(pageNo)"]
        params[Keys.search] = searchText
        params[Keys.profileUserId] = Authorization.shared.profile?.userId
        
        ServiceManager.shared.fetchFriendsList(params: params) { [weak self] (data, _) in
            guard let unsafe = self else { return }
            Utils.hideSpinner()
            
            if unsafe.pageNo == 1 {
                unsafe.friendsList.removeAll()
            }
            
            if let list = data {
                if list.count > 0 {
                    var users = [Friend]()
                    for object in list {
                        users.append(object)
                        if let first = object.user?.firstName?.first {
                            if let value = unsafe.friendsList[first.description.lowercased()]  as? [Friend] {
                                let filter = value.filter { $0.user?.id == object.user?.id }
                                if filter.count == 0 {
                                    var tempUser = [Friend]()
                                    tempUser.append(contentsOf: value)
                                    tempUser.append(object)
                                    unsafe.friendsList[first.description.lowercased()] = tempUser
                                }
                            } else {
                                unsafe.friendsList[first.description.lowercased()] = [object]
                            }
                        }
                    }
                    
                    if unsafe.pageNo == 1 {
                        unsafe.friendListAraay = users
                    } else {
                        unsafe.friendListAraay.append(contentsOf: users)
                    }
                    unsafe.pageNo += 1
                    unsafe.isNextPageExist = true
                } else {
                    unsafe.isNextPageExist = false
                    if unsafe.pageNo == 1 {
                        unsafe.friendListAraay.removeAll()
                    }
                }
                
                unsafe.isRushFriends =  unsafe.friendListAraay.count > 0 ? true : false
                unsafe.getContacts()
                unsafe.tableView.reloadData()
            }
            
        }
    }
}
