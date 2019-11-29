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
    func fetchEventList(sortBy: String, params: [String: Any], closer: @escaping (_ events: [Event]?, _ total: Int, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getEventList(sortBy: sortBy, params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (events, total, errorMessage) in
                closer(events, total, errorMessage)
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
    func fetchInviteeList(eventId: String, params: [String: Any], closer: @escaping (_ list: [Invitee]?, _ count: Int, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getInviteeList(eventId: eventId, params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (invitees, total, errorMessage) in
                closer(invitees, total, errorMessage)
            })
        }
    }
    
    func fetchInviteeListWithSession(eventId: String, params: [String: Any], closer: @escaping (_ list: [Invitee]?, _ count: Int, _ errorMessage: String?) -> Void) -> URLSessionDataTask? {
        NetworkManager.shared.getInviteeListWithSession(eventId: eventId, params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (invitees, total, errorMessage) in
                closer(invitees, total, errorMessage)
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
    
    func fetchEventCategoryWithEventList(params: [String: Any], closer: @escaping (_ eventCategory: [Interest]?, _ errorMessage: String?) -> Void) {
             NetworkManager.shared.getEventCategoryWithEventList(params: params) { [weak self] (data, error, code) in
                 guard let unsafe = self else { return }
                 unsafe.procesModelResponse(result: data, error: error, code: code, closer: { (eventCategory, _, errorMessage) in
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
    func fetchCalendarList(params: [String: Any], closer: @escaping (_ events: [CalendarItem]?, _ classes: [CalendarItem]?, Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.getCalendarList(params: params) { [weak self] (data, error, code) in
            guard let unsafe = self else { return }
            unsafe.processDataResponse(result: data, error: error, code: code, closer: { (data, errorMessage) in
                var events: [CalendarItem]?
                var classes: [CalendarItem]?
                var isScheduledAnything = false
                if let items = data?[Keys.events] as? [[String: Any]] {
                    if let list: [CalendarItem] = unsafe.decodeObject(fromData: items) {
                       events = list
                    }
                }
                
                if let items = data?[Keys.classes] as? [[String: Any]] {
                    if let list: [CalendarItem] = unsafe.decodeObject(fromData: items) {
                       classes = list
                    }
                }
                
                if let isScheduled = data?[Keys.isScheduledAnything] as? Int {
                    isScheduledAnything = isScheduled == 1 ? true : false
                }
                
                closer(events, classes, isScheduledAnything, errorMessage)
            })
        }
    }
    
    func updateEvent(eventId: String, params: [String: Any], closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.updateEvent(eventId: eventId, params: params) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }
    
    func deletePhoto(photoId: String, closer: @escaping (_ status: Bool, _ errorMessage: String?) -> Void) {
        NetworkManager.shared.deletePhoto(photoId: photoId) { [weak self] (data, error, code) in
            guard let uwself = self else { return }
            uwself.processNoDataResponse(result: data, error: error, code: code, closer: { (status, errorMessage) in
                closer(status, errorMessage)
            })
        }
    }

}
