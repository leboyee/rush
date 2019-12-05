//
//  HomeMediates.swift
//  Rush
//
//  Created by Chirag on 09/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension ClassDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = screenWidth
        tableView.rowHeight = UITableView.automaticDimension
        
        let headerNib =   UINib(nibName: ReusableView.userImagesHeader, bundle: nil)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: ReusableView.userImagesHeader)
        tableView.register(UINib(nibName: ReusableView.textHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: ReusableView.textHeader)
        
        var cells = [Cell.clubName, Cell.clubManage, Cell.createUserPost, Cell.timeSlot, Cell.eventByDate, Cell.eventType, Cell.textIcon]
        cells.append(contentsOf: [Cell.singleButtonCell, Cell.userPostText, Cell.userPostImage, Cell.postLike, Cell.postUser, Cell.postImages, Cell.postBottom, Cell.textView])
        
        for cell in cells {
            tableView.register(UINib(nibName: cell, bundle: nil), forCellReuseIdentifier: cell)
        }
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return joinedClub ? (6 + classesPostList.count) : 6
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
        } else if indexPath.section == 2 || indexPath.section == 3 {
            if indexPath.section == 2 && isShowMore {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.timeSlot, for: indexPath) as? TimeSlotCell else { return UITableViewCell() }
                fillTimeSlotCell(cell, indexPath)
                return cell
            } else {
                if indexPath.section == 3 {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.textView, for: indexPath) as? TextViewCell else { return UITableViewCell() }
                    fillTextViewCell(cell)
                    return cell
                } else {
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.textIcon, for: indexPath) as? TextIconCell else { return UITableViewCell() }
                    fillTimeCell(cell, indexPath)
                    return cell
                }
            }
        } else if indexPath.section == 4 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventType, for: indexPath) as? EventTypeCell else { return UITableViewCell() }
            fillJoinedUserCell(cell)
            return cell
        } else if indexPath.section == 5 {
            if joinedClub {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.createUserPost, for: indexPath) as? CreateUserPostCell else { return UITableViewCell() }
                cell.setup(font: UIFont.semibold(sz: 13))
                cell.setup(titleColor: UIColor.lightGrayColor)
                cell.setup(url: Authorization.shared.profile?.photo?.urlThumb())
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
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.postImages, for: indexPath) as? PostImagesCell else { return UITableViewCell() }
                fillPostImageCell(cell, indexPath)
                return cell
            } else if indexPath.row == 3 {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: Cell.postBottom, for: indexPath) as? PostBottomCell else { return UITableViewCell() }
                fillPostBottomCell(cell, indexPath)
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
        if (section == 2 && isShowMore == false) || section == 3 {
            return footer
        }
        let separator = UIView(frame: CGRect(x: (section == 2 && isShowMore == false) ?  24 : 0, y: (isShowMore && section == 2) ? 15 : 0, width: screenWidth, height: (section == 1 && joinedClub == false) ? 0 : 1))
        footer.addSubview(separator)
        separator.backgroundColor = UIColor.separatorColor
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return heightOfFooter(section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 2 || section == 3 || section == 1 || section == 0 {
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
extension ClassDetailViewController {
    private func animateHeader() {
        self.heightConstraintOfHeader.constant = headerFullHeight
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
}
// MARK: - SharePostViewControllerDelegate
extension ClassDetailViewController: SharePostViewControllerDelegate {
    func shareObject(_ object: Any?) {
        var data = [Any]()
        if let post = object as? Post {
            var userName = "my"
            if post.userId != Int(Authorization.shared.profile?.userId ?? "-1") {
                userName = post.user?.firstName ?? "this"
            }
            data.append("Check out \(userName) post in Rush app:\n")
            
            data.append("\(post.text ?? "")")
            if let urls = post.images?.compactMap({ $0.urlMedium() }) {
                for url in urls {
                    do {
                        data.append(UIImage(data: try Data(contentsOf: url)) as Any)
                    } catch {}
                }
            }
        } else if let cls = object as? SubClass {
            data.append("Check out \(cls.name) class in Rush app")
            //data.append("\n\(selectedGroup?.name ?? "")")
            if let clubImage = clubHeader.userImageView.image {
                data.append(clubImage)
            }
        }
        Utils.openActionSheet(controller: self, shareData: data)
    }
    
    func delete(type: SharePostType, object: Any?) {
        if type == .post, let post = object as? Post {
            deletePostAPI(id: post.postId)
        }
    }
}
// MARK: - OtherUserProfile delegate
extension ClassDetailViewController: OtherUserProfileProtocol {
    func unfriendUser(_ name: String) {
        let snackbar = TTGSnackbar(message: "You unfriended \(name)",
            duration: .middle,
            actionText: "",
            actionBlock: { (_) in })
        snackbar.show()
    }
}
// MARK: - PostVIewController delegate
extension ClassDetailViewController: PostViewProtocol {
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

// MARK: - CreatePostViewController Delegate
extension ClassDetailViewController: CreatePostViewControllerDelegate {
    func createPostSuccess(_ post: Post) {
        //performSegue(withIdentifier: Segues.postSegue, sender: post)
    }
    
    func showSnackBar(text: String, buttonText: String) {
        /*
         notificationTitle = text
         notificationButtonTitle = buttonText
         performSegue(withIdentifier: Segues.notificationAlert, sender: nil)
         */
        /*
         let snackbar = TTGSnackbar(message: text,
         duration: .middle,
         actionText: buttonText,
         actionBlock: { (_) in
         
         })
         snackbar.show()
         */
    }
}
