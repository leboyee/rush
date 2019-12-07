//
//  EventDetailViewController.swift
//  Rush
//
//  Created by kamal on 27/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import MapKit
import SendBirdSDK

enum EventDetailType {
    case my
    case joined
    case invited
    case other
    case rejected
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

class EventDetailViewController: BaseTableViewController {

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
    var totalInvitee: Int = 0
    var isFromChatDetail = false
    
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
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.userProfile, object: nil)
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
        
        /// Set Header Delegate
        header.delegate = self
        updateHeaderInfo()
        NotificationCenter.default.addObserver(self, selector: #selector(userProfile), name: Notification.Name.userProfile, object: nil)
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
        performSegue(withIdentifier: Segues.eventDetailShare, sender: event)
    }
    
    @objc func userProfile(notification: NSNotification) {
        if let user = notification.userInfo?["user"] as? User {
            showUserProfile(user: user)
        }
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
        guard let event = event else {
            header.set(date: nil)
            return
        }
        header.set(date: event.start)
        header.set(start: event.start, end: event.end)
        header.set(url: event.photo?.urlLarge())
    }
    
    func sharePost(post: Post) {
        performSegue(withIdentifier: Segues.eventDetailShare, sender: post)
    }
    
    func showRSVP(action: String) {
        performSegue(withIdentifier: Segues.rsvpJoinEvent, sender: action)
    }
    
    func showCreatePost() {
        performSegue(withIdentifier: Segues.createEventPost, sender: nil)
    }
    
    func showComments(post: Post) {
        performSegue(withIdentifier: Segues.eventPostDetail, sender: post)
    }
    
    func showMessage(message: String) {
        Utils.alert(message: message)
    }
    
    func openGroupChat() {
        let controller = ChatRoomViewController()
        controller.userName = event?.title ?? ""
        controller.isGroupChat = true
        controller.eventInfo = event
        controller.chatDetailType = .event
        controller.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(controller, animated: true)
        
        Utils.showSpinner()
        
        ChatManager().getListOfAllPublicChatGroups(type: "event", data: "\(event?.id ?? 0)", { [weak self] (data) in
            guard let unsafe = self else { return }
            Utils.hideSpinner()
            let controller = ChatRoomViewController()
            controller.isGroupChat = true
            controller.eventInfo = unsafe.event
            controller.chatDetailType = .event
            controller.userName = unsafe.event?.title ?? ""
            controller.hidesBottomBarWhenPushed = true
            
            if let channels = data as? [SBDGroupChannel], channels.count > 0 {
                let filterChannel = channels.filter({ $0.data == "\(unsafe.event?.id ?? 0)" })
                controller.channel = filterChannel.first
                if filterChannel.first?.hasMember(Authorization.shared.profile?.userId ?? "") ?? false {
                    
                } else {
                    filterChannel.first?.join(completionHandler: { (error) in
                        if error != nil {
                            print(error?.localizedDescription ?? "")
                        }
                    })
                }
            }
            unsafe.navigationController?.pushViewController(controller, animated: true)
            }, errorHandler: { (error) in
                print(error?.localizedDescription ?? "")
        })
    }
    
    func showJoinAlert() {
        performSegue(withIdentifier: Segues.eventWithoutRSVPJoinedPopup, sender: nil)
    }
    
    func showUserProfile(user: User) {
        if user.userId == Authorization.shared.profile?.userId {
            tabBarController?.selectedIndex = 3
        } else {
            performSegue(withIdentifier: Segues.eventOtherUserProfile, sender: user)
        }
    }
    
    func showInviteeUserProfile(invitee: Invitee) {
        if invitee.user?.userId == Authorization.shared.profile?.userId {
            tabBarController?.selectedIndex = 3
        } else {
            performSegue(withIdentifier: Segues.eventOtherUserProfile, sender: invitee)
        }
    }
    
    func showInvitedPeopleList() {
        performSegue(withIdentifier: Segues.eventInvitedPeople, sender: nil)
    }
    
    func showPostImages(post: Post, index: Int) {
        performSegue(withIdentifier: Segues.eventPostImages, sender: (post, index))
    }
    
    func showCalendar() {
        performSegue(withIdentifier: Segues.eventDetailCalendar, sender: nil)
    }
    
    func showInterestBasedEvent(_ interest: Interest) {
        performSegue(withIdentifier: Segues.eventInterest, sender: interest)
    }
    
    func showLocationOnMap() {
        if let lat = event?.latitude, let lon = event?.longitude, let latitude = Double(lat), let longitude = Double(lon) {
            // Set the region of the map that is rendered.
            let coordinates = CLLocationCoordinate2DMake(latitude, longitude)
            let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 500, longitudinalMeters: 500)
            let options = [
                MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
                MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)
            ]
            
            let placemark = MKPlacemark(coordinate: coordinates, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            mapItem.name = event?.address
            mapItem.openInMaps(launchOptions: options)
        }
    }
    
    func deleteEventSuccessfully() {
        navigationController?.viewControllers.forEach({ (vc) in
            if vc.isKind(of: CalendarViewController.self) {
                (vc as? CalendarViewController)?.reloadEvents()
            }
        })
        backButtoAction()
    }
}

// MARK: - Navigations
extension EventDetailViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.rsvpJoinEvent {
            if let vc = segue.destination as? RSVPViewController {
                vc.event = event
                if let action = sender as? String {
                  vc.action = action
                }
            }
        } else if segue.identifier == Segues.createEventPost {
            if let nvc = segue.destination as? UINavigationController, let vc = nvc.viewControllers.first as? CreatePostViewController {
                vc.eventInfo = event
                vc.delegate = self
            }
        } else if segue.identifier == Segues.eventPostDetail {
            if let vc = segue.destination as? PostViewController {
                vc.eventInfo = event
                vc.postInfo = sender as? Post
                vc.delegate = self
            }
        } else if segue.identifier == Segues.eventDetailShare {
            if let vc = segue.destination as? SharePostViewController {
                vc.delegate = self
                if (sender as? Post) != nil {
                    vc.type = .post
                } else {
                    vc.type = .event
                }
                vc.object = sender
            }
        } else if segue.identifier == Segues.eventWithoutRSVPJoinedPopup {
            let vc = segue.destination as? EventJoinedPopupViewController
            vc?.event = event
        } else if segue.identifier == Segues.eventOtherUserProfile {
            if let vc = segue.destination as? OtherUserProfileController {
                vc.delegate = self
                if let user = sender as? User {
                   vc.userInfo = user
                } else if let invitee = sender as? Invitee {
                    vc.userInfo = invitee.user
                    if type == .my {
                        vc.rsvpQuestion = event?.rsvp
                        vc.rsvpAnswer = invitee.rsvpAns
                    }
                }
            }
        } else if segue.identifier == Segues.editEventSegue {
            if let vc = segue.destination as? CreateEventViewController {
                vc.event = event
                vc.isEditEvent = true
            }
        } else if segue.identifier == Segues.eventDetailCalendar {
            if let vc = segue.destination as? CalendarViewController {
                vc.selectedDate = event?.start ?? Date()
            }
        } else if segue.identifier == Segues.eventInvitedPeople {
            if let vc = segue.destination as? EventGoingFriendsViewController {
                vc.eventId = event?.id ?? 0
            }
        } else if segue.identifier == Segues.eventPostImages {
              if let vc = segue.destination as? UserProfileGalleryViewController {
                if let (post, index) = sender as? (Post, Int) {
                    vc.list = post.images ?? [Image]()
                    vc.user = post.user ?? User()
                    vc.currentIndex = index
                    vc.isFromOtherUserProfile = true
                }
              }
        } else if segue.identifier == Segues.eventInterest {
            if let vc = segue.destination as? EventCategoryListViewController {
                vc.interest = sender as? Interest
                vc.type = .event
            }
        }
    }
}
