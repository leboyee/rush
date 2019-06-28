//
//  PostMediates.swift
//  Rush
//
//  Created by ideveloper on 25/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit


extension PostViewController :UITableViewDelegate,UITableViewDataSource {
    
    func setupTableView() {
        
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 500
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: Cell.userName, bundle: nil), forCellReuseIdentifier: Cell.userName)
        tableView.register(UINib(nibName: Cell.userPostText, bundle: nil), forCellReuseIdentifier: Cell.userPostText)
        tableView.register(UINib(nibName: Cell.userPostImage, bundle: nil), forCellReuseIdentifier: Cell.userPostImage)
        tableView.register(UINib(nibName: Cell.postLikeCell, bundle: nil), forCellReuseIdentifier: Cell.postLikeCell)
        tableView.register(UINib(nibName: Cell.postCommentCell, bundle: nil), forCellReuseIdentifier: Cell.postCommentCell)
        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return commentList.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.userName, for: indexPath) as! UserNameTableViewCell
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.userPostText, for: indexPath) as! UserPostTextTableViewCell
            fillTextViewCell(cell)
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.userPostImage, for: indexPath) as! UserPostImageTableViewCell
            fillImageCell(cell, indexPath)
            return cell
        } else if indexPath.section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.postLikeCell, for: indexPath) as! PostLikeCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Cell.postCommentCell, for: indexPath) as! PostCommentCell
            fillCommentCell(cell, indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.textHeader) as! TextHeader
        fillTextHeader(header, section)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 4 ? 36 : CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}

// MARK: - Textview delegate
extension PostViewController: GrowingTextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        
        let text = textView.text.replacingOccurrences(of: username, with: "")
        commentText = textView.text
        textView.attributedText = Utils.setAttributedText(username, text, 17, 17)
        if textView.text.count > 0 {
            sendButton.setBackgroundImage(#imageLiteral(resourceName: "send_active"), for: .normal)
        } else {
            sendButton.setBackgroundImage(#imageLiteral(resourceName: "send"), for: .normal)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        let text = textView.text.replacingOccurrences(of: username, with: "")
        textView.attributedText = Utils.setAttributedText(username, text, 17, 17)
    }
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

//MARK: - SharePostViewControllerDelegate
extension PostViewController : SharePostViewControllerDelegate {
    func deletePost() {
        performSegue(withIdentifier: Segues.notificationAlert, sender: nil)
    }
}

//MARK: - Notification alert delegate
extension PostViewController: NotificationAlertDelegate {
    func undoButtonClickEvent() {
        
    }
}

