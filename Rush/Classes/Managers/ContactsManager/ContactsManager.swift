//
//  ContactsManager.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import Foundation
import Contacts

class ContactsManager: NSObject {
    
    var store = CNContactStore()
    var skipPerameter: Int = 0
    
    
    static let contactManager = ContactsManager()


    //MARK : USER CONTACT SYNC
    func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            completionHandler(false)
        case .restricted, .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async {
                        completionHandler(false)
                    }
                }
            }
        @unknown default:
            fatalError()
        }
    }
    
    func retrieveContactsWithStore() -> ([Contact]) {
        
        let keys = CNContactFormatter.descriptorForRequiredKeys(for: .fullName)
        let keysToFetch = [CNContactEmailAddressesKey, CNContactPhoneNumbersKey,CNContactBirthdayKey,CNContactPostalAddressesKey,CNContactImageDataKey,keys] as [Any]
        let containerId = CNContactStore().defaultContainerIdentifier()
        let _: NSPredicate = CNContact.predicateForContactsInContainer(withIdentifier: containerId)
        
        // Get all the containers
        var allContainers: [CNContainer] = []
        do {
            allContainers = try store.containers(matching: nil)
        } catch {
            print("Error fetching containers")
        }
        
        var contacts:[CNContact] = []
        
        // Iterate all containers and append their contacts to our results array
        for container in allContainers {
            let fetchPredicate = CNContact.predicateForContactsInContainer(withIdentifier: container.identifier)
            
            do {
                let containerResults = try store.unifiedContacts(matching: fetchPredicate, keysToFetch: keysToFetch as! [CNKeyDescriptor])
                contacts.append(contentsOf: containerResults)
            } catch {
                print("Error fetching results for container")
            }
        }
        //contacts = contacts.filterDuplicate{ ($0.identifier) }
        var contactArray : [Contact] = []
        for contact: CNContact in contacts {
            
            let contactIdentifier = "Profile:\(contact.identifier)"
                let contactModel = Contact()
                contactModel.origin = contactIdentifier
                contactModel.id = contact.identifier
                contactModel.displayName = "\(contact.givenName) \(contact.familyName)"
                if let dateComponents = contact.birthday {
                    
                    if let month = dateComponents.month, let day = dateComponents.day {
                        if let year  = dateComponents.year {
                            contactModel.birthday = Date().standardServerFormatterDateFromString(dateString: ("\(year)-\(month)-\(day)"))
                        } else {
                            contactModel.birthday = Date().standardServerFormatterDateFromString(dateString: ("\(Date().year)-\(month)-\(day)"))
                        }
                    }
                }
                
                if contact.phoneNumbers.count > 0 {
                    contactModel.phone = (contact.phoneNumbers[0].value).value(forKey: "digits") as? String ?? ""
                }
                
                /*if let email = contact.emailAddresses.first?.value as String?, ValidatorManager.shared.isValid(email: email) {
                    contactModel.email = email
                }
                
                if contact.postalAddresses.count > 0 {
                    let street = (contact.postalAddresses[0].value).value(forKey: "street") as? String ?? ""
                    let subLocality = (contact.postalAddresses[0].value).value(forKey: "subLocality") as? String ?? ""
                    let address1 = "\(street) \(subLocality)"
                    let city = (contact.postalAddresses[0].value).value(forKey: "city") as? String ?? ""
                    let state = (contact.postalAddresses[0].value).value(forKey: "state") as? String ?? ""
                    let zip = (contact.postalAddresses[0].value).value(forKey: "postalCode") as? String ?? ""
                    let addressModel = AddressModel(city: city, state: state, zip: zip, address1: address1, address2: "")
                    
                    contactModel.address = addressModel
                    
                }*/
                contactArray.append(contactModel)
            
        }
        return contactArray
    }

    
    func getUserContacts(completionHandler: @escaping (_ contacts :[Contact], _ success: Bool, _ error: String) -> Void) {
        self.requestAccess(completionHandler: { [weak self] (access) in
            guard let strongSelf = self else {return}
            
            if (access) {
                let contact =  strongSelf.retrieveContactsWithStore()
                if contact.count > 0 {
                    completionHandler(contact,true,"Success!")
                }
                else {
                    completionHandler(contact,true,"Success")
                }
            }
            else {
                let message = "This app requires access to Contacts to proceed. Would you like to open settings and grant permission to contacts?."
                completionHandler([Contact](),false,message)
            }
        })
    }



}

extension Array
{
    func filterDuplicate<T>(_ keyValue:(Element)->T) -> [Element]
    {
        var uniqueKeys = Set<String>()
        return filter{uniqueKeys.insert("\(keyValue($0))").inserted}
    }
}



