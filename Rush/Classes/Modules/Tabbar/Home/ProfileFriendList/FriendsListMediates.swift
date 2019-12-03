//
//  FriendsListMediates.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension FriendsListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 56
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: Cell.friendList, bundle: nil), forCellReuseIdentifier: Cell.friendList)
        tableView.register(UINib(nibName: Cell.eventByDate, bundle: nil), forCellReuseIdentifier: Cell.eventByDate)
        tableView.register(UINib(nibName: Cell.friendClub, bundle: nil), forCellReuseIdentifier: Cell.friendClub)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let row = cellCount(section)
        if row == 0 {
            if type == .friends {
                if firstSegmentButton.isSelected {
                    noDataLabel.text = "\(userInfo?.name ?? "User") has no friends."
                } else {
                    noDataLabel.text = "You have no mutual friends with \(userInfo?.name ?? "User")."
                }
            } else  if type == .clubs {
                if firstSegmentButton.isSelected {
                    noDataLabel.text = "\(userInfo?.name ?? "User") has not joined any clubs yet."
                } else {
                    noDataLabel.text = "\(userInfo?.name ?? "User") has not managing any clubs yet."
                }
            } else  if type == .events {
                if firstSegmentButton.isSelected {
                    noDataLabel.text = "\(userInfo?.name ?? "User") is not attending any events."
                            } else {
                    noDataLabel.text = "\(userInfo?.name ?? "User") is not managing any events."
                }
            } else  if type == .classRoasters {
                if firstSegmentButton.isSelected {
                    noDataLabel.text = "\(userInfo?.name ?? "User") has no friends."
                } else {
                    noDataLabel.text = "You have no mutual friends with \(userInfo?.name ?? "User")."
                }
            } else {
                
            }
            noDataLabel.isHidden = false
        } else {
            noDataLabel.isHidden = true
        }
        return row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if type == .friends || type == .clubJoinedUsers || type == .classRoasters {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.friendList, for: indexPath) as? FriendListCell else { return UITableViewCell() }
            fillCell(cell, indexPath)
            return cell
        } else if type == .events {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventByDate, for: indexPath) as? EventByDateCell else { return UITableViewCell() }
            fillEventByDateCell(cell, indexPath)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.friendClub, for: indexPath) as? FriendClubCell else { return UITableViewCell() }
            fillFriendClubCell(cell, indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .events || type == .clubs || type == .friends || type == .classes || type == .clubJoinedUsers || type == .classRoasters {
            selectedCell(indexPath)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplay(indexPath)
    }
}

extension FriendsListViewController: UITextFieldDelegate {
    @objc func textDidChange(_ textField: UITextField) {
        searchText = textField.text ?? ""
        pageNo = 1
        isNextPageExist = false
        if type == .clubJoinedUsers {
            fetchClubInviteeAPI()
        } else if type == .classRoasters {
            fetchClassRostersAPI()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
// MARK: - OtherUserProfile delegate
extension FriendsListViewController: OtherUserProfileProtocol {
    func unfriendUser(_ name: String) {
        let snackbar = TTGSnackbar(message: "You unfriended \(name)",
            duration: .middle,
            actionText: "",
            actionBlock: { (_) in
        })
        snackbar.show()
    }
}
