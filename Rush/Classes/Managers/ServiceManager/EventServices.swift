//
//  EventServices.swift
//  Rush
//
//  Created by kamal on 10/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
extension ServiceManager {
    
    // Event List API
    func fetchEventList(sortBy: String, params: [String: Any], closer: @escaping (_ events: [Event]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getEventList(sortBy: sortBy, params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (events, errorMessage) in
                closer(events, errorMessage)
            })
            /*
            unsafe.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
            */
        }
    }
    
    // Event Detail API
    func fetchEventDetail(eventId: String, closer: @escaping (_ params: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getEventDetail(eventId: eventId) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
    
    // Join Event API
    func joinEvent(eventId: String, params: [String: Any], closer: @escaping (_ data: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.joinEvent(eventId: eventId, params: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
}
