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
        ContactsManager().getUserContacts {  [weak self] (contacts, status, message) in
            guard let self_ = self else { return }
            for contact in contacts {
                var sectionKey = ""
                guard let firstLetter = contact.displayName.first else {continue}
                let firstLetterString = String(firstLetter).capitalized
                sectionKey = firstLetterString
                if self_.itemsDictionary[sectionKey] == nil {
                    self_.itemsDictionary[sectionKey] = [Contact]()
                }
                if var models = self_.itemsDictionary[sectionKey] {
                    models.append(contact)
                    self_.itemsDictionary[sectionKey] = models
                }
            }
            
            self_.items = self_.itemsDictionary.map { (key, value) -> ContactsPresenterItem in
                return (key, value)
                }.sorted(by: {
                    return $0.key < $1.key
                })
            print(self_.items)
            Utils.hideSpinner()
            self_.tableView.reloadData()
        }
    }
}
