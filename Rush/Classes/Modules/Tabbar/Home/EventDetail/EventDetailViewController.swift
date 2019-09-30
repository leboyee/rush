//
//  EventDetailViewController.swift
//  Rush
//
//  Created by kamal on 27/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

enum EventDetailType {
    case my
    case joined
    case invited
    case other
}

enum EventSectionType {
    case about
    case manage
    case location
    case invitee
    case tags
    case createPost
    case post
    case organizer
    case joinRsvp
}

enum PostCellType {
    case none
    case user
    case text
    case image
    case like
    
}

struct EventSection {
    var type: EventSectionType
    var title: String?
}

class EventDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var header: EventHeader!

    var type: EventDetailType = .my
    var sections: [EventSection]?
    var eventId: String?
    let headerHeight: CGFloat = 47.0
    let friendHeight: CGFloat = 88.0
    var event: Event?
    var postList: [Post]?
    var inviteeList: [Invitee]?

    let headerFullHeight: CGFloat = 367
    let headerSmallWithDateHeight: CGFloat = 182
    let headerSmallWithoutDateHeight: CGFloat = 114

    var postPageNo = 1
    var isPostNextPageExist = false
    let downloadQueue = DispatchQueue(label: "com.messapps.profileImages")
    let downloadGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        downloadGroup.notify(queue: downloadQueue) {
            DispatchQueue.main.async {
                self.reloadTable()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}

// MARK: - Setup and Privacy
extension EventDetailViewController: UIGestureRecognizerDelegate {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
        
        //left gesture when back button hide or replaced
        if let gesture = navigationController?.interactivePopGestureRecognizer {
            gesture.delegate = self
        }
        
        setupTableView()
        loadAllData()
        tableView.isHidden = true
        Utils.showSpinner()
    }
}

// MARK: - Actions
extension EventDetailViewController {

    @IBAction func backButtoAction() {
        navigationController?.popViewController(animated: true)
    }
   
    @IBAction func shareButtoAction() {
        Utils.notReadyAlert()
    }
    
}

// MARK: - Others
extension EventDetailViewController {
    
    func reloadTable() {
        self.tableView.isHidden = false
        self.tableView.reloadData()
        Utils.hideSpinner()
    }
    
    func updateHeaderInfo() {
        guard let event = event else { return }
        header.set(date: event.start)
        header.set(start: event.start, end: event.end)
        header.set(url: event.photo?.url())
    }
    
    func showRSVP() {
        performSegue(withIdentifier: Segues.rsvpJoinEvent, sender: nil)
    }
    
    func showCreatePost() {
        performSegue(withIdentifier: Segues.createEventPost, sender: nil)
    }
    
    func showComments(post: Post) {
        performSegue(withIdentifier: Segues.eventPostDetail, sender: post)
    }
}

// MARK: - Navigations
extension EventDetailViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.rsvpJoinEvent {
            if let vc = segue.destination as? RSVPViewController {
                vc.event = event
            }
        } else if segue.identifier == Segues.createEventPost {
            if let vc = segue.destination as? CreatePostViewController {
                vc.eventInfo = event
            }
        } else if segue.identifier == Segues.eventPostDetail {
            if let vc = segue.destination as? PostViewController {
                vc.eventInfo = event
                vc.postInfo = sender as? Post
            }
        }
    }
}
