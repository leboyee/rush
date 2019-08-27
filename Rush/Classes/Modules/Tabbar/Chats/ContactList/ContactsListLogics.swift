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
        Utils.showSpinner()
        ContactsManager().getUserContacts { [weak self] (contacts, status, message) in
            guard let unself = self else { return }
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
            print(unself.items)
            Utils.hideSpinner()
            unself.tableView.reloadData()
        }
    }
}
