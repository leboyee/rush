//
//  ContactsListLogics.swift
//  Rush
//
//  Created by ideveloper on 17/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ContactsListViewController {
    
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
