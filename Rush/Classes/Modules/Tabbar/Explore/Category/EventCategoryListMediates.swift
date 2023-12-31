//
//  FriendsListMediates.swift
//  Rush
//
//  Created by ideveloper on 05/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension EventCategoryListViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == .none {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventByDate, for: indexPath) as? EventByDateCell else { return UITableViewCell() }
            return cell
        } else if type == .event {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventByDate, for: indexPath) as? EventByDateCell else { return UITableViewCell() }
            fillEventCell(cell, indexPath)
            return cell
        } else if type == .club || type == .classes {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.friendClub, for: indexPath) as? FriendClubCell else { return UITableViewCell() }
            fillClubCell(cell, indexPath)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected(indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if type == .event && isNextPage && indexPath.row == eventList.count - 2 {
            pageNo += 1
            loadAPIforPaging()
        } else if type == .club && isNextPage && indexPath.row == clubList.count - 2 {
            pageNo += 1
            loadAPIforPaging()
        } else if type == .classes && isNextPage && indexPath.row == classList.count - 2 {
            pageNo += 1
            loadAPIforPaging()
        }
        
    }
}

// MARK: - Collectionview delegate methods
extension EventCategoryListViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: Cell.sortingCell, bundle: nil), forCellWithReuseIdentifier: Cell.sortingCell)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.sortingCell, for: indexPath) as? SortingCell else { return UICollectionViewCell() }
        fillSortingCell(cell, indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionCellSelected(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 8)
    }
}

// MARK: - SeachField delegate
extension EventCategoryListViewController: UITextFieldDelegate {
    @objc func textDidChange(_ textField: UITextField) {
        searchText = textField.text ?? ""
        isNextPage = false
        pageNo = 1
        eventList.removeAll()
        clubList.removeAll()
        classList.removeAll()
        if hasCalledAPI == 0 {
            hasCalledAPI = 1
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.loadAPIforPaging()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "" { return true }
        let maxLength = 50
        let currentString: NSString = textField.text as NSString? ?? ""
        var newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        if string.count >= maxLength {
            newString = String(string.prefix(maxLength)) as NSString
            textField.text = newString as String
            return false
        }
        return  textField.text?.count ?? 0 < maxLength
    }

}
