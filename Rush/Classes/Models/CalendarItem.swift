//
//  CalendarItem.swift
//  Rush
//
//  Created by kamal on 08/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class GroupClassSchedule: Codable {
    var id = ""
    var classId = ""
    var groupId = ""
    var day = ""
    var start = ""
    var end = ""
    var timezone = ""

    private enum CodingKeys: String, CodingKey {
        case id = "_id"
        case classId = "class_id"
        case groupId = "group_id"
        case day = "day"
        case start = "start_time"
        case end = "end_time"
        case timezone
    }
}

class CalendarItem: Decodable {
    private var id: Int64 = 0
    var type = ""
    var title = ""
    private var photoJson: String = ""
    private var convertJsonToPhoto: Image?
    var photo: Image? {
       if convertJsonToPhoto == nil {
         convertJsonToPhoto = photoJson.photo
       }
       return convertJsonToPhoto
    }
    var start: Date?
    var end: Date?
    var classSchedule: [GroupClassSchedule]?
    
    var itemId: String {
        return String(id)
    }
    
    private enum CodingKeys: String, CodingKey {
       case id = "data_id"
       case type = "data_type"
       case title = "data_name"
       case photoJson = "data_photo"
       case start = "data_start_date"
       case end = "data_end_date"
       case classSchedule = "data_group_schedule"
    }
    
    required init(from decoder: Decoder) {
        let container = try? decoder.container(keyedBy: CodingKeys.self)
        id = (try? container?.decode(Int64.self, forKey: .id)) ?? 0
        type = (try? container?.decode(String.self, forKey: .type)) ?? ""
        title = (try? container?.decode(String.self, forKey: .title)) ?? ""
        photoJson = (try? container?.decode(String.self, forKey: .photoJson)) ?? ""
        
        if let startDate = try? container?.decode(String.self, forKey: .start) {
            if let date = Date.parseUTC(dateString: startDate) {
               start = date
            }
        }
        
        if let endDate = try? container?.decode(String.self, forKey: .end) {
            if let date = Date.parseUTC(dateString: endDate) {
               end = date
            }
        }
        
        if let list = try? container?.decode([GroupClassSchedule].self, forKey: .classSchedule) {
            classSchedule = list
        }
    }
}
