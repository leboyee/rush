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
    case other
    case joined
}

enum EventSectionType {
    case about
    case manage
    case location
    case people
    case tags
    case createPost
    case posts
    case organizer
    case joinRsvp
}


struct EventSection {
    var type: EventSectionType
    var title: String?
}

class EventDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var type: EventDetailType = .my
    var sections: [EventSection]?
    var eventId: String?
    let headerHeight: CGFloat = 47.0
    let friendHeight: CGFloat = 88.0
    var event: Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

// MARK: - Setup and Privacy
extension EventDetailViewController {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
        
        setupTableView()
        loadAllData()
    }
}

// MARK: - Actions
extension EventDetailViewController {

}

// MARK: - Others
extension EventDetailViewController {
    
}

//MARK: - Navigations
extension EventDetailViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}
