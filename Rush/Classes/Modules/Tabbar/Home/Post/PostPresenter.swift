//
//  PostPresenter.swift
//  Rush
//
//  Created by ideveloper on 25/06/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension PostViewController {
    
    func cellHeight(_ indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            if (postInfo?.images?.count ?? 0) > 0 {
                return screenWidth
            }
            return CGFloat.leastNormalMagnitude
        } else {
            return UITableView.automaticDimension
        }
    }
    
    // Username cell (section 0)
    func userDetailCell(_ cell: UserNameTableViewCell) {
        if let club = clubInfo { // Club
            cell.setup(title: club.user?.name ?? "")
            cell.setup(detail: "Posting in " + (club.clubName ?? ""))
        }
    }
    
    // Textview cell (section 1)
    func fillTextViewCell(_ cell: UserPostTextTableViewCell) {
        cell.setup(text: postInfo?.text ?? "", placeholder: "")
        cell.setup(font: UIFont.regular(sz: 17))
    }
    
    // Image cell (section 2)
    func fillImageCell(_ cell: UserPostImageTableViewCell, _ indexPath: IndexPath) {
        if let images = postInfo?.images {
            cell.set(url: images.first?.url())
        }
        cell.setup(isCleareButtonHide: true)
    }
    
    func fillTextHeader(_ header: TextHeader, _ section: Int) {
        if commentList.count > 0 {
            header.setup(title: Text.comments)
        } else {
            header.setup(title: "")
        }
        header.setup(isDetailArrowHide: true)
    }
    
    // Comment cell
    func fillCommentCell(_ cell: PostCommentCell, _ indexPath: IndexPath) {
        
        /*
        if indexPath.row == 0 {
            cell.setup(isReplayCell: false)
        } else if indexPath.row == 1 {
            cell.setup(isReplayCell: true)
            cell.setup(name: "Peter Rally", attributedText: "")
        } else {
            cell.setup(isReplayCell: false)
        }
        */
        let comment = commentList[indexPath.row]
        cell.setup(username: comment.user?.name ?? "")
        cell.setup(commentText: comment.desc ?? "")
        
        cell.userProfileClickEvent = { [weak self] () in
            guard let unself = self else { return }
            unself.performSegue(withIdentifier: Segues.otherUserProfile, sender: nil)
        }
        
        cell.userNameClickEvent = { [weak self] (name) in
            guard let unself = self else { return }
            unself.username = "Peter Rally"
            unself.textView.attributedText = Utils.setAttributedText(unself.username, ", can I bring friends?", 17, 17)
            unself.textView.becomeFirstResponder()
        }
        
        cell.replyClickEvent = { [weak self] () in
            guard let unself = self else { return }
            unself.parentComment = comment
            unself.textView.becomeFirstResponder()
        }
    }
    
    func fillLikeCell(_ cell: PostLikeCell, _ indexPath: IndexPath) {
        if let post = postInfo {
            cell.set(numberOfLike: post.numberOfLikes)
            cell.set(numberOfUnLike: post.numberOfUnLikes)
            cell.set(numberOfComment: post.numberOfComments)
            cell.set(ishideUnlikeLabel: false)
            
            cell.likeButtonEvent = { [weak self] () in
                guard let uwself = self else { return }
                uwself.voteClubAPI(id: post.id ?? "", type: "up")
            }
            
            cell.unlikeButtonEvent = { [weak self] () in
                guard let uwself = self else { return }
                uwself.voteClubAPI(id: post.id ?? "", type: "down")
                
            }
        }
    }
}

// MARK: - Services
extension PostViewController {
    func voteClubAPI(id: String, type: String) {
        ServiceManager.shared.votePost(postId: id, voteType: type) { [weak self] (result, errorMsg) in
            guard let uwself = self else { return }
            if let post = result {
                uwself.postInfo = post
                uwself.tableView.reloadData()
                uwself.delegate?.updatedPost(post)
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func addCommentAPI() {
        
        let param = [Keys.desc: textView.text ?? "",
                     Keys.postId: postInfo?.id ?? "",
                     Keys.parentId: parentComment != nil ? (parentComment?.id ?? "0") : ""] as [String: Any]
        
        Utils.showSpinner()
        ServiceManager.shared.postComment(params: param) { [weak self] (status, errorMsg) in
            guard let unsafe = self else { return }
            if status {
                unsafe.getAllCommentListAPI()
            } else {
                Utils.hideSpinner()
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func getAllCommentListAPI() {
        parentComment = nil
        ServiceManager.shared.fetchCommentList(postId: postInfo?.id ?? "") { [weak self] (data, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if let value = data {
                unsafe.commentList = value
                unsafe.tableView.reloadData()
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func deletePostAPI() {
        
        let id = postInfo?.id ?? "0"
        Utils.showSpinner()
        ServiceManager.shared.deletePost(postId: id, params: [Keys.postId: id]) { [weak self] (status, errorMsg) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            if status {
                unsafe.delegate?.deletePostSuccess(unsafe.postInfo)
                DispatchQueue.main.async {
                    unsafe.navigationController?.popViewController(animated: true)
                }
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
}
