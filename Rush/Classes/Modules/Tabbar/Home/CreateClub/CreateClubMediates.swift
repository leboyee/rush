//
//  HomeMediates.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension CreateClubViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 64
        tableView.rowHeight = UITableView.automaticDimension
        
        let headerNib =   UINib(nibName: ReusableView.userImagesHeader, bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: ReusableView.userImagesHeader)
        tableView.register(UINib(nibName: Cell.textIcon, bundle: nil), forCellReuseIdentifier: Cell.textIcon)
        tableView.register(UINib(nibName: Cell.textView, bundle: nil), forCellReuseIdentifier: Cell.textView)
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 5 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.textIcon, for: indexPath) as? TextIconCell else { return UITableViewCell() }
            fillTextIconCell(cell, indexPath)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.textView, for: indexPath) as? TextViewCell else { return UITableViewCell() }
            fillTextViewCell(cell, indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Segues.createEventInviteSegue, sender: self)
            }
        } else if indexPath.section == 2 {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Segues.createEventInterestSegue, sender: self)
            }
        } else if indexPath.section == 4 {
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Segues.addUniversitySegue, sender: self)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
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

// MARK: - Scrollview delegate
extension CreateClubViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if clubImage != nil || clubHeader.userImageView.image != nil {
            let topMergin = (AppDelegate.shared?.window?.safeAreaInsets.top ?? 0)
            let smallHeaderHeight = headerSmallWithoutDateHeight
            let smallHeight = smallHeaderHeight + topMergin
            let h = heightConstraintOfHeader.constant - scrollView.contentOffset.y
            let height = min(max(h, smallHeight), screenHeight)
            self.heightConstraintOfHeader.constant = height
            if !smallHeight.isEqual(to: height) {
                tableView.contentOffset = CGPoint(x: 0, y: 0)
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.heightConstraintOfHeader.constant > headerFullHeight {
            animateHeader()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.heightConstraintOfHeader.constant > headerFullHeight {
            animateHeader()
        }
    }
    
    private func animateHeader() {
        self.heightConstraintOfHeader.constant = headerFullHeight
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

// MARK: - Club header delegate
extension CreateClubViewController: ClubHeaderDelegate {
    func infoOfClub() {
        
    }
    
    func addPhotoOfClub() {
                self.performSegue(withIdentifier: Segues.selectEventPhoto, sender: self)
        //openCameraOrLibrary(type: .photoLibrary)
    }
}

// MARK: - Add Interest Delegate
extension CreateClubViewController: EventInterestDelegate {
    func  selectedInterest(_ interest: [Interest]) {
        self.interestList = interest
        validateAllFields()
        self.tableView.reloadData()
    }
}

// MARK: - Add Invities Delegate
extension CreateClubViewController: EventInviteDelegate {
    func selectedInvities(_ invite: [Invite]) {
        
        if clubInfo != nil {
            var newPeopleList = [Invite]()
            for tempInvite in invite {
                
                if tempInvite.isFriend {
                    let friendFilter = peopleList.filter({ $0.isFriend == true })
                    let filter = friendFilter.filter({ $0.profile?.userId == tempInvite.profile?.userId })
                    if filter.count == 0 {
                        newPeopleList.append(tempInvite)
                        if let id = tempInvite.profile?.userId {
                            newPeopleIds.append(id)
                        }
                    }
                } else {
                    let contactFilter = peopleList.filter({ $0.isFriend == false })
                    let filter = contactFilter.filter({ $0.contact?.displayName ==  tempInvite.contact?.displayName })
                    if filter.count == 0 {
                        newPeopleList.append(tempInvite)
                        if let id = tempInvite.contact?.phone {
                            newContacts.append(id)
                        }
                    }
                }
            }
            
            peopleList.append(contentsOf: newPeopleList)
            validateAllFields()
            tableView.reloadData()
            
        } else {
            peopleList = invite
            validateAllFields()
            tableView.reloadData()
        }
    }
}

// MARK: - Choose University delegate
extension CreateClubViewController: ChooseUnivesityDelegate {
    func selectedUniversity(_ university: University) {
        self.selectedUniversity = university
        self.validateAllFields()
        self.tableView.reloadData()
    }
}
