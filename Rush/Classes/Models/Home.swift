//
//  Home.swift
//  Rush
//
//

import UIKit

class Home: Codable {
    
    var myEvents: [Event]?
    var interestedEvents: [Event]?
    var interestedClubList: [Club]?
    var classList: [SubClass]?
    
    init() {
    }
    
    private enum CodingKeys: String, CodingKey {
        case myEvents
        case interestedEvents
        case interestedClubList
        case classList
    }
}
