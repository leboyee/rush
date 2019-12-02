//
//  PostMediates.swift
//  Rush
//
//  Created by ideveloper on 25/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension PostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        
        tableView.layer.cornerRadius = 24
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 500
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: Cell.userName, bundle: nil), forCellReuseIdentifier: Cell.userName)
        tableView.register(UINib(nibName: Cell.userPostText, bundle: nil), forCellReuseIdentifier: Cell.userPostText)
        tableView.register(UINib(nibName: Cell.userPostImage, bundle: nil), forCellReuseIdentifier: Cell.userPostImage)
        tableView.register(UINib(nibName: Cell.postBottom, bundle: nil), forCellReuseIdentifier: Cell.postBottom)
        
        tableView.register(UINib(nibName: Cell.postCommentCell, bundle: nil), forCellReuseIdentifier: Cell.postCommentCell)
        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (commentList.count + 4)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section > 3 {
            return (commentList[section - 4].threadComment?.count ?? 0) + 1
        } else if section == 2 && postInfo != nil {
            return postInfo?.images?.count ?? 0
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
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.userPostImage, for: indexPath) as? UserPostImageTableViewCell else { return UITableViewCell() }
            fillImageCell(cell, indexPath)
            return cell
        } else if indexPath.section == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.postBottom, for: indexPath) as? PostBottomCell else { return UITableViewCell() }
            fillPostBottomCell(cell, indexPath)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.postCommentCell, for: indexPath) as? PostCommentCell else { return UITableViewCell() }
            
            if indexPath.row == 0 {
                fillParentCommentCell(cell, indexPath)
            } else {
                fillChildCommentCell(cell, indexPath)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.textHeader) as? TextHeader else { return UIView() }
        fillTextHeader(header, section)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 4 ? 36 : CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        loadMoreCell(indexPath)
    }
}

// MARK: - Textview delegate
extension PostViewController: GrowingTextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        commentText = textView.text
        
        if parentComment != nil {
            if let name = parentComment?.user?.name {
                let text = textView.text.replacingOccurrences(of: name, with: "")
                textView.attributedText = Utils.setAttributedText(name, text, 17, 17)
            }
        } else {
            textView.attributedText = Utils.setAttributedText("", textView.text, 17, 17)
        }
        
        if textView.text.count > 0 {
            sendButton.setBackgroundImage(#imageLiteral(resourceName: "send_active"), for: .normal)
        } else {
            sendButton.setBackgroundImage(#imageLiteral(resourceName: "send"), for: .normal)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if parentComment != nil {
            if let name = parentComment?.user?.name {
                let text = textView.text.replacingOccurrences(of: name, with: "")
                textView.attributedText = Utils.setAttributedText(name, text, 17, 17)
            }
        }
    }
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - SharePostViewControllerDelegate
extension PostViewController: SharePostViewControllerDelegate {
    func shareObject(_ object: Any?) {
        if let post = object as? Post {
            var data = [Any]()
          /*  if let urls = post.images?.compactMap({ $0.urlMedium() }) {
                data.append(contentsOf: urls)
            }*/
            var userName = "my"
            if post.userId != Int(Authorization.shared.profile?.userId ?? "-1") {
                userName = post.user?.firstName ?? "this"
            }
            data.append("Check out \(userName)'s post in Rush app:\n")
            data.append("\(post.text ?? "")")
            if let urls = post.images?.compactMap({ $0.urlMedium() }) {
                for url in urls {
                    do {
                        data.append(UIImage(data: try Data(contentsOf: url)) as Any)
                    } catch {}
                }
            }
            Utils.openActionSheet(controller: self, shareData: data)
        }
    }
    
    func delete(type: SharePostType, object: Any?) {
        deletePostAPI()
    }
}

// MARK: - OtherUserProfile delegate
extension PostViewController: OtherUserProfileProtocol {
    func unfriendUser(_ name: String) {
        let snackbar = TTGSnackbar(message: "You unfriended \(name)",
            duration: .middle,
            actionText: "",
            actionBlock: { (_) in
        })
        snackbar.show()
    }
}
