//
//  HomeMediates.swift
//  Rush
//
//  Created by ideveloper2 on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ClubDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        let headerNib =   UINib(nibName: ReusableView.userImagesHeader, bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: ReusableView.userImagesHeader)
        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
        
        let cells = [Cell.clubName, Cell.clubManage, Cell.createUserPost, Cell.tag, Cell.eventByDate, Cell.eventType, Cell.singleButtonCell, Cell.userPostText, Cell.userPostImage, Cell.postLike, Cell.postUser]
        
        for cell in cells {
            tableView.register(UINib(nibName: cell, bundle: nil), forCellReuseIdentifier: cell)
        }
        
        tableView.reloadData()
        
        fillImageHeader()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return joinedClub ? (6 + clubPostList.count) : 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.clubName, for: indexPath) as? ClubNameCell else { return UITableViewCell() }
            fillClubNameCell(cell)
            return cell
        } else if indexPath.section == 1 {
            if joinedClub {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.clubManage, for: indexPath) as? ClubManageCell else { return UITableViewCell() }
                fillClubManageCell(cell)
                return cell
            } else {
                return UITableViewCell()
            }
        } else if indexPath.section == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventType, for: indexPath) as? EventTypeCell else { return UITableViewCell() }
            fillJoinedUserCell(cell)
            return cell
        } else if indexPath.section == 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventByDate, for: indexPath) as? EventByDateCell else { return UITableViewCell() }
            fillEventByDateCell(cell, indexPath)
            return cell
        } else if indexPath.section == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.tag, for: indexPath) as? TagCell else { return UITableViewCell() }
            fillTagCell(cell)
            return cell
        } else if indexPath.section == 5 {
            if joinedClub {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.createUserPost, for: indexPath) as? CreateUserPostCell else { return UITableViewCell() }
                cell.setup(font: UIFont.semibold(sz: 13))
                return cell
            } else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.singleButtonCell, for: indexPath) as? SingleButtonCell else { return UITableViewCell() }
                fillSingleButtonCell(cell)
                return cell
            }
        } else {
            if indexPath.row == 0 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.postUser, for: indexPath) as? PostUserCell else { return UITableViewCell() }
                fillPostUserCell(cell, indexPath)
                return cell
            } else if indexPath.row == 1 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.userPostText, for: indexPath) as? UserPostTextTableViewCell else { return UITableViewCell() }
                fillTextViewCell(cell, indexPath)
                return cell
            } else if indexPath.row == 2 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.userPostImage, for: indexPath) as? UserPostImageTableViewCell else { return UITableViewCell() }
                fillImageCell(cell, indexPath)
                return cell
            } else if indexPath.row == 3 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.postLike, for: indexPath) as? PostLikeCell else { return UITableViewCell() }
                fillLikeCell(cell, indexPath)
                return cell
            } else {
                return UITableViewCell()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellSelected(indexPath)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footer = UIView()
        let separator = UIView(frame: CGRect(x: section == 2 ?  24 : 0, y: 0, width: screenWidth, height: 1))
        footer.addSubview(separator)
        separator.backgroundColor = UIColor.separatorColor
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightOfFooter(section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            return UIView()
        } else {
            guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.textHeader) as? TextHeader else { return UIView() }
            fillTextHeader(header, section)
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightOfHeader(section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
    
    // MARK: - Scroll Delegates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
}

extension ClubDetailViewController {
    private func animateHeader() {
        self.heightConstraintOfHeader.constant = headerFullHeight
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
}

// MARK: - OtherUserProfile delegate
extension ClubDetailViewController: OtherUserProfileProtocol {
    func unfriendUser(_ name: String) {
        let snackbar = TTGSnackbar(message: "You unfriended \(name)",
            duration: .middle,
            actionText: "Undo",
            actionBlock: { (_) in
                Utils.notReadyAlert()
        })
        snackbar.show()
    }
}

// MARK: - PostVIewController delegate
extension ClubDetailViewController: PostViewProtocol {
    func deletePostSuccess(_ post: Post?) {
        let snackbar = TTGSnackbar(message: "Your post is deleted.",
                                   duration: .middle,
                                   actionText: "",
                                   actionBlock: { (_) in
        })
        snackbar.show()
    }
    
    func updatedPost(_ post: Post) {
        
    }
}

// MARK: - CreatePostViewController delegate
extension ClubDetailViewController: CreatePostViewControllerDelegate {
    func showSnackBar(text: String, buttonText: String) {
        
    }
    
    func createPostSuccess(_ post: Post) {
        isCallAPI = false
        performSegue(withIdentifier: Segues.postSegue, sender: post)
    }
}

// MARK: - SharePostViewControllerDelegate
extension ClubDetailViewController: SharePostViewControllerDelegate {
    func delete(type: SharePostType, object: Any?) {
        if type == .club {
            deleteClubAPI()
        } else if type == .post, let post = object as? Post {
            deletePostAPI(id: post.postId)
        }
    }
}

// MARK: - CreateClubDelegate
extension ClubDetailViewController: CreateClubProtocol {
    func updateClubSuccess() {
        isCallAPI = true
        getClubDetailAPI()
    }
}
