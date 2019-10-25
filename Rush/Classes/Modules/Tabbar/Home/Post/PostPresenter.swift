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
        
        if let post = postInfo {
            if post.userId == Int(Authorization.shared.profile?.userId ?? "-1") {
                cell.setup(title: Authorization.shared.profile?.name ?? "")
                cell.setup(url: Authorization.shared.profile?.photo?.urlThumb())
            } else {
                cell.setup(title: post.user?.name ?? "")
                cell.setup(url: post.user?.photo?.url())
            }
        }
        
        if let subclass = subclassInfo { // Subclass
            cell.setup(detail: "Posting in " + (subclass.name))
        } else if let club = clubInfo {
            cell.setup(detail: "Posting in " + (club.clubName ?? ""))
        } else if let event = eventInfo {
            cell.setup(detail: "Posting in " + (event.title))
        }
    }
    
    // Textview cell (section 1)
    func fillTextViewCell(_ cell: UserPostTextTableViewCell) {
        cell.setup(text: postInfo?.text ?? "", placeholder: "")
        cell.setup(font: UIFont.regular(sz: 17))
        cell.setup(isUserInterectionEnable: false)
    }
    
    // Image cell (section 2)
    func fillImageCell(_ cell: UserPostImageTableViewCell, _ indexPath: IndexPath) {
        if let images = postInfo?.images {
            let img = images[indexPath.row]
            cell.set(url: img.url())
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
    
    // Comment parent cell
    func fillParentCommentCell(_ cell: PostCommentCell, _ indexPath: IndexPath) {
        
        let comment = commentList[indexPath.section - 4]
        cell.setup(username: comment.user?.name ?? "")
        cell.setup(commentText: comment.desc ?? "")
        cell.setup(image: comment.user?.photo?.url())
        cell.setup(isReplayCell: false)
        
        let local = Date().UTCToLocal(date: comment.createDate ?? "")
        if let date = Date.parse(dateString: local) {
            let time = Date().timeAgoDisplay(date: date)
            cell.setup(date: time)
        }
        
        cell.userProfileClickEvent = { [weak self] () in
            guard let unself = self else { return }
            unself.performSegue(withIdentifier: Segues.otherUserProfile, sender: nil)
        }
        
        cell.replyClickEvent = { [weak self] () in
            guard let unself = self else { return }
            unself.parentComment = comment
            if let name = comment.user?.name {
                unself.textView.placeHolder = ""
                unself.textView.attributedText  = Utils.setAttributedText(name, ", ", 17, 17)
            }
            unself.textView.becomeFirstResponder()
        }
    }
    
    // Comment child cell
    func fillChildCommentCell(_ cell: PostCommentCell, _ indexPath: IndexPath) {
        
        let comment = commentList[indexPath.section - 4].threadComment?[indexPath.row - 1]
        cell.setup(username: comment?.user?.name ?? "")
        
        var desc = comment?.desc ?? ""
        desc = desc.replacingOccurrences(of: "[@|{}]", with: "", options: .regularExpression, range: nil)
        let mensionId = "\(comment?.mentionedUser?.first?.id ?? 0)"
        if desc.contains(mensionId) {
            desc = desc.replacingOccurrences(of: mensionId, with: "")
            cell.setup(name: comment?.mentionedUser?.first?.name ?? "", attributedText: desc)
        } else {
            cell.setup(commentText: comment?.desc ?? "")
        }
        cell.setup(isReplayCell: true)
        cell.setup(image: comment?.user?.photo?.url())
        
        let local = Date().UTCToLocal(date: comment?.createDate ?? "")
        if let date = Date.parse(dateString: local) {
            let time = Date().timeAgoDisplay(date: date)
            cell.setup(date: time)
        }
        
        cell.userProfileClickEvent = { [weak self] () in
            guard let unself = self else { return }
            unself.performSegue(withIdentifier: Segues.otherUserProfile, sender: nil)
        }
        
        cell.replyClickEvent = { [weak self] () in
            guard let unself = self else { return }
            unself.parentComment = comment
            if let name = comment?.user?.name {
                unself.textView.placeHolder = ""
                unself.textView.attributedText  = Utils.setAttributedText(name, ", ", 17, 17)
            }
            unself.textView.becomeFirstResponder()
        }
    }
    
    func fillLikeCell(_ cell: PostLikeCell, _ indexPath: IndexPath) {
        if let post = postInfo {
            cell.set(numberOfLike: post.numberOfLikes)
            cell.set(numberOfUnLike: post.numberOfUnLikes)
            cell.set(numberOfComment: post.numberOfComments)
            cell.set(ishideUnlikeLabel: false)
            if let myVote = post.myVote?.first {
                cell.set(vote: myVote.type)
            } else {
                cell.set(vote: 0)
            }
            cell.likeButtonEvent = { [weak self] () in
                guard let uwself = self else { return }
                uwself.voteClubAPI(id: post.postId, type: "up")
            }
            
            cell.unlikeButtonEvent = { [weak self] () in
                guard let uwself = self else { return }
                uwself.voteClubAPI(id: post.postId, type: "down")
                
            }
        }
    }
    
    func fillPostBottomCell(_ cell: PostBottomCell, _ indexPath: IndexPath) {
        if let post = postInfo {
            cell.set(numberOfLike: post.totalUpVote)
            cell.set(numberOfComment: post.numberOfComments)
            if let myVote = post.myVote?.first {
                cell.set(vote: myVote.type)
            } else {
                cell.set(vote: 0)
            }
            
            cell.likeButtonEvent = { [weak self] () in
                self?.voteClubAPI(id: post.postId, type: Vote.up)
            }
            
            cell.unlikeButtonEvent = { [weak self] () in
                self?.voteClubAPI(id: post.postId, type: Vote.down)
            }
        }
    }
    
    func loadMoreCell(_ indexPath: IndexPath) {
        if commentList.count > 2 {
            if indexPath.row == (commentList.count - 2) && isNextPageExistP {
                getAllCommentListAPI()
            }
        }
    }
}

// MARK: - Services
extension PostViewController {
    
    func getPostDetailAPI() {
        
        let id = postInfo?.postId ?? ""
        ServiceManager.shared.fetchPostDetail(postId: id, params: [Keys.postId: id]) { [weak self] (result, errorMsg) in
            guard let uwself = self else { return }
            if let post = result {
                uwself.postInfo = post
                uwself.pageNoP = 1
                uwself.getAllCommentListAPI()
                uwself.delegate?.updatedPost(post)
            } else {
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
        
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
        
        var param = [String: Any]()
        param[Keys.postId] = postInfo?.postId ?? ""
        
        if let id = parentComment?.id, var desc = textView.text, let name = parentComment?.user?.name, let userId = parentComment?.userId {
            desc = desc.replacingOccurrences(of: name, with: "")
            param[Keys.parentId] = id
            param[Keys.desc] = "{{||@\(userId)||}}\(desc)"
            param[Keys.menstionUserId] = parentComment?.userId ?? ""
        } else {
            param[Keys.desc] = textView.text ?? ""
        }
        username = ""
        textView.text = ""
        
        Utils.showSpinner()
        ServiceManager.shared.postComment(params: param) { [weak self] (status, errorMsg) in
            guard let unsafe = self else { return }
            if status {
                unsafe.pageNoP = 1
                unsafe.isNextPageExistP = true
                unsafe.username = ""
                unsafe.textView.text = ""
                unsafe.textView.attributedText = nil
                unsafe.commentList.removeAll()
                unsafe.getPostDetailAPI()
            } else {
                Utils.hideSpinner()
                Utils.alert(message: errorMsg ?? Message.tryAgainErrorMessage)
            }
        }
    }
    
    func getAllCommentListAPI() {
        parentComment = nil
        
        let param = ["post_id": postInfo?.postId ?? "",
                     "parent_id": parentComment?.id ?? "",
                     Keys.pageNo: pageNoP] as [String: Any]
        
        ServiceManager.shared.fetchCommentList(postId: postInfo?.postId ?? "", params: param) { [weak self] (data, _) in
            Utils.hideSpinner()
            guard let unsafe = self else { return }
            
            if unsafe.pageNoP == 1 {
                unsafe.commentList.removeAll()
            }
            
            if let value = data, value.count > 0 {
                unsafe.updateCommentCount = value.count
                if unsafe.pageNoP == 1 {
                    unsafe.commentList = value
                } else {
                    unsafe.commentList.append(contentsOf: value)
                }
                
                unsafe.getAllChildComment()
                
                unsafe.pageNoP += 1
                unsafe.isNextPageExistP = true
                unsafe.tableView.reloadData()
            } else {
                unsafe.isNextPageExistP = false
                if unsafe.pageNoP == 1 {
                    unsafe.commentList.removeAll()
                }
            }
        }
    }
    
    func getAllChildComment() {
        getChildCommentListAPI(index: finishCommentCount) { (_) in
            if self.finishCommentCount < self.updateCommentCount {
                self.getAllChildComment()
            }
        }
    }
    
    func getChildCommentListAPI(index: Int, complition: @escaping(_ isSuccess: Bool) -> Void) {
        
        guard commentList.count > index else { return }
        let comment = commentList[index]
        if comment.threadComment?.count == 0 {
            self.finishCommentCount += 1
            complition(true)
        } else {
            let param = ["post_id": postInfo?.postId ?? "",
                         "parent_id": comment.id ?? "",
                         Keys.pageNo: pageNoP] as [String: Any]
            
            parentComment = nil
            ServiceManager.shared.fetchCommentList(postId: postInfo?.postId ?? "", params: param) { [weak self] (data, _) in
                guard let unsafe = self else { return }
                if let value = data, value.count > 0 {
                    unsafe.commentList[index].threadComment = value
                }
                unsafe.finishCommentCount += 1
                complition(true)
            }
        }
    }
    
    func deletePostAPI() {
        
        let id = postInfo?.postId ?? "0"
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
