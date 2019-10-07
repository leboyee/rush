//
//  EventDetailViewController.swift
//  Rush
//
//  Created by kamal on 27/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import MapKit

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
        performSegue(withIdentifier: Segues.eventDetailShare, sender: event)
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
        header.set(url: event.photo?.urlLarge())
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
        controller.isShowTempData = false
        controller.userName = event?.title ?? ""
        controller.isGroupChat = true
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func showJoinAlert() {
        performSegue(withIdentifier: Segues.eventWithoutRSVPJoinedPopup, sender: nil)
    }
    
    func showUserProfile(user: User) {
        performSegue(withIdentifier: Segues.eventOtherUserProfile, sender: user)
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
                vc.type = .event
                vc.object = sender
            }
        } else if segue.identifier == Segues.eventWithoutRSVPJoinedPopup {
            let vc = segue.destination as? EventJoinedPopupViewController
            vc?.event = event
        } else if segue.identifier == Segues.eventOtherUserProfile {
            if let vc = segue.destination as? OtherUserProfileController {
                vc.userInfo = sender as? User
                vc.delegate = self
            }
        } else if segue.identifier == Segues.editEventSegue {
            if let vc = segue.destination as? CreateEventViewController {
                vc.event = event
                vc.isEditEvent = true
            }
        }
    }
}
