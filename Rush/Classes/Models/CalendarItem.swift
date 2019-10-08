//
//  CalendarItem.swift
//  Rush
//
//  Created by kamal on 08/10/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

class CalendarItem: Codable {
    var id = ""
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

    enum CodingKeys: String, CodingKey {
       case id = "data_id"
       case type = "data_type"
       case title = "data_title"
       case photoJson = "data_photo"
    }
    
//    required init(from decoder: Decoder) {
//        let container = try? decoder.container(keyedBy: CodingKeys.self)
//        id = (try? container?.decode(String.self, forKey: .id)) ?? ""
//        type = (try? container?.decode(String.self, forKey: .type)) ?? ""
//        title = (try? container?.decode(String.self, forKey: .title)) ?? ""
//        photoJson = (try? container?.decode(String.self, forKey: .photoJson)) ?? ""
//    }
}
