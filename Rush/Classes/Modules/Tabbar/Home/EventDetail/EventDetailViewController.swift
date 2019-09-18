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
    case people
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
    var postlist: [Post]?

    let headerFullHeight: CGFloat = 367
    let headerSmallWithDateHeight: CGFloat = 182
    let headerSmallWithoutDateHeight: CGFloat = 114

    let tempInvitee = [
         Invitees(name: "Kamal"),
         Invitees(name: "John"),
         Invitees(name: "Smith"),
         Invitees(name: "Suresh"),
         Invitees(name: "Chirag")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
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
    
    func updateHeaderInfo() {
        guard let event = event else { return }
        header.set(date: event.date)
        header.set(start: event.start, end: event.end)
        header.set(url: URL(string: event.thumbnil ?? ""))
    }
    
    func showRSVP() {
        performSegue(withIdentifier: Segues.rsvpJoinEvent, sender: nil)
    }
    
}

// MARK: - Navigations
extension EventDetailViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.rsvpJoinEvent {
            if let vc = segue.destination as? RSVPViewController {
                vc.event = event
            }
        }
    }
}
