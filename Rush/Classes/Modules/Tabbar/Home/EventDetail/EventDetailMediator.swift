//
//  EventDetailMediator.swift
//  Rush
//
//  Created by kamal on 27/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

extension EventDetailViewController {
    
    func setupTableView() {
        tableView.layer.cornerRadius = topViewRadius
        tableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tableView.keyboardDismissMode = .onDrag
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 414.0
        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(cellName: Cell.eventAbout)
        tableView.register(cellName: Cell.eventType)
        tableView.register(cellName: Cell.clubManage)
        tableView.register(cellName: Cell.location)
        tableView.register(cellName: Cell.createPost)
        tableView.register(cellName: Cell.singleButtonCell)
        tableView.register(cellName: Cell.organizer)
        tableView.register(cellName: Cell.postUser)
        tableView.register(cellName: Cell.postText)
        tableView.register(cellName: Cell.postImages)
        tableView.register(cellName: Cell.postBottom)
        tableView.register(reusableViewName: ReusableView.textHeader)
        tableView.reloadData()
    }
    
    func setupHeader() {
        // setup header
        // header.delegate = self
    }
    
}

extension EventDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount(section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight(indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let type = sectionType(section: indexPath.section)
        if type == .post {
            let type = postCellType(indexPath: indexPath)
            switch type {
            case .user:
                if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.postUser, for: indexPath) as? PostUserCell {
                    fillPostUserCell(cell, indexPath)
                    return cell
                }
            case .text:
                if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.postText, for: indexPath) as? PostTextCell {
                    fillPostTextCell(cell, indexPath)
                    return cell
                }
            case .image:
                if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.postImages, for: indexPath) as? PostImagesCell {
                    fillPostImageCell(cell, indexPath)
                    return cell
                }
            case .like:
                if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.postBottom, for: indexPath) as? PostBottomCell {
                    fillPostBottomCell(cell, indexPath)
                    return cell
                }
            default:
                break
            }
        } else if type == .joinRsvp {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.singleButtonCell, for: indexPath) as? SingleButtonCell {
                fillSingleButtonCell(cell)
                return cell
            }
        } else if type == .about {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventAbout, for: indexPath) as? EventAboutCell {
                fillAboutCell(cell, indexPath)
                return cell
            }
        } else if type == .manage {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.clubManage, for: indexPath) as? ClubManageCell {
                fillManageCell(cell)
                return cell
            }
        } else if type == .location {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.location, for: indexPath) as? LocationCell {
                fillLocationCell(cell)
                return cell
            }
        } else if type == .createPost {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.createPost, for: indexPath) as? CreatePostCell {
                fillCreatePostCell(cell)
                return cell
            }
        } else if type == .organizer {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.organizer, for: indexPath) as? OrganizerCell {
                fillOrganizerCell(cell)
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: Cell.eventType, for: indexPath) as? EventTypeCell {
                fillEventTypeCell(cell, indexPath)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow(indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        willDisplay(indexPath)
    }
    
    // MARK: - Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeight(section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReusableView.textHeader) as? TextHeader {
            fillTextHeader(header, section)
            return header
        }
        return nil
    }
    
    // MARK: - Footer
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return sectionFooter(section)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return RSeparatorLine()
    }
    
    // MARK: - Scroll Delegates
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let topMergin = (AppDelegate.shared?.window?.safeAreaInsets.top ?? 0)
        let smallHeaderHeight = event?.start == nil ? headerSmallWithoutDateHeight : headerSmallWithDateHeight
        let smallHeight = smallHeaderHeight + topMergin
        let h = headerHeightConstraint.constant - scrollView.contentOffset.y
        let height = min(max(h, smallHeight), screenHeight)
        self.headerHeightConstraint.constant = height
        if !smallHeight.isEqual(to: height) {
            tableView.contentOffset = CGPoint(x: 0, y: 0)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.headerHeightConstraint.constant > headerFullHeight {
            animateHeader()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if self.headerHeightConstraint.constant > headerFullHeight {
            animateHeader()
        }
    }
}

extension EventDetailViewController {
    private func animateHeader() {
        self.headerHeightConstraint.constant = headerFullHeight
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
    }
}

extension EventDetailViewController: SharePostViewControllerDelegate {
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
            
            Utils.openActionSheet(controller: self, shareData: data)
        } else if let evnt = object as? Event {
            
            let storyboardName = UIStoryboard(name: StoryBoard.chat, bundle: nil)
            guard let controller = storyboardName.instantiateViewController(withIdentifier: "ChatsViewController") as? ChatsViewController else { return }
            controller.sharedEvent = evnt
            controller.isOpenToShare = true
            controller.delegate = self
            let navigationController = UINavigationController.init(rootViewController: controller)
            navigationController.modalPresentationStyle = .fullScreen
            self.present(navigationController, animated: true, completion: nil)
            
        }
       
    }
    
    func delete(type: SharePostType, object: Any?) {
        if type == .event, let event = object as? Event {
            deleteEvent(event: event)
        } else if type == .post, let post = object as? Post {
            deletePost(post: post)
        }
    }
}

// MARK: - ChatsViewControllerDelegate
extension EventDetailViewController: ChatsViewControllerDelegate {
    func sharedResult(flg: Bool) {
        if flg {
            Utils.alert(message: "\(event?.title ?? "") event shared!")
        } else {
            Utils.alert(message: "Something wrong on event sharing.")
        }
    }
}

// MARK: - OtherUserProfile delegate
extension EventDetailViewController: OtherUserProfileProtocol {
    func unfriendUser(_ name: String) { }
}

// MARK: - PostVIewController delegate
extension EventDetailViewController: PostViewProtocol {
    func deletePostSuccess(_ post: Post?) {
        // Find index of post, remove and reload list
        if let post = post, let index = postList?.firstIndex(where: { $0.postId == post.postId }) {
            postList?.remove(at: index)
            reloadTable()
        }
    }
    
    func updatedPost(_ post: Post) {
        // Find index of post and replace with updated post
        if let index = postList?.firstIndex(where: { $0.postId == post.postId }) {
            postList?[index] = post
            reloadTable()
        }
    }
    
}

// MARK: - CreatePostViewController delegate
extension EventDetailViewController: CreatePostViewControllerDelegate {
    func showSnackBar(text: String, buttonText: String) { }
    
    func createPostSuccess(_ post: Post) {
        loadPosts()
        // https://www.wrike.com/open.htm?id=410213843
        //performSegue(withIdentifier: Segues.eventPostDetail, sender: post)
    }
}

// MARK: - EventHeader delegate
extension EventDetailViewController: EventHeaderDelegate {
    func didTappedCalendar() {
        showCalendar()
    }
}
