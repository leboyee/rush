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
        }
    }
    
    // Event Detail API
    func fetchEventDetail(eventId: String, closer: @escaping (_ event: Event?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getEventDetail(eventId: eventId) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                if let object = data?[Keys.event] as? [String: Any] {
                    let event: Event? = unsafe.decodeObject(fromData: object)
                     closer(event, errorMessage)
                } else {
                     closer(nil, errorMessage)
                }
            })
        }
    }
    
    // Event Detail API
    func fetchInviteeList(eventId: String, params: [String: Any], closer: @escaping (_ list: [Invitee]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getInviteeList(eventId: eventId, params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (invitees, errorMessage) in
                closer(invitees, errorMessage)
            })
        }
    }
    
    // Join Event API
    func joinEvent(eventId: String, action: String, params: [String: Any], closer: @escaping (_ data: [String: Any]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.joinEvent(eventId: eventId, action: action, params: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                closer(data, errorMessage)
            })
        }
    }
    
    func rejectEventInvitation(eventId: String, closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.joinEvent(eventId: eventId, action: EventAction.reject, params: [:]) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    // Event category API
    func fetchEventCategoryList(params: [String: Any], closer: @escaping (_ eventCategory: [EventCategory]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getEventCategoryList(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (eventCategory, errorMessage) in
                closer(eventCategory, errorMessage)
            })
        }
    }
    
    func fetchEventCategoryWithEventList(params: [String: Any], closer: @escaping (_ eventCategory: [EventCategory]?, _ errorMessage: String?) -> Void) {
             NetworkManager.shared.getEventCategoryWithEventList(params: params) { [weak self] (data, error, code) in
                 guard let unsafe = self else { return }
                 unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (eventCategory, errorMessage) in
                     closer(eventCategory, errorMessage)
                 })
             }
         }
    
    // Delete Event API
    func deleteEvent(eventId: String, closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.deleteEvent(eventId: eventId) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    // Calendar List API
    func fetchCalendarList(params: [String: Any], closer: @escaping (_ items: [CalendarItem]?, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getCalendarList(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (list, errorMessage) in
                closer(list, errorMessage)
            })
        }
    }
}
