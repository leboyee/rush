//
//  CreatePostMediates.swift
//  Rush
//
//  Created by ideveloper2 on 12/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension CreatePostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        
        tableView.layer.cornerRadius = 24
        tableView.layer.borderWidth = CGFloat.leastNormalMagnitude
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: Cell.userName, bundle: nil), forCellReuseIdentifier: Cell.userName)
        tableView.register(UINib(nibName: Cell.userPostText, bundle: nil), forCellReuseIdentifier: Cell.userPostText)
        tableView.register(UINib(nibName: Cell.userPostImage, bundle: nil), forCellReuseIdentifier: Cell.userPostImage)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if imageList.count > 0 {
            return 3
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return imageList.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.userName, for: indexPath) as? UserNameTableViewCell else { return UITableViewCell() }
            userDetailCell(cell)
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.userPostText, for: indexPath) as? UserPostTextTableViewCell else { return UITableViewCell() }
            fillTextViewCell(cell)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.userPostImage, for: indexPath) as? UserPostImageTableViewCell else { return UITableViewCell() }
            fillImageCell(cell, indexPath)
//            cell.setNeedsLayout()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
}

// MARK: - DKCamera delegate methods
extension CreatePostViewController {
    
}
