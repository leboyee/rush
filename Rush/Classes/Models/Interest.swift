//
//  Interest.swift
//  Interest
//
//  Created by kamal on 28/01/19.
//  Copyright © 2019 Kamal Mittal. All rights reserved.
//

import UIKit

class Interest: Profile {
    
    var interestId: Int64 = 0
    var interestName: String = ""
    
    override init(data : [String : Any]) {
        super.init(data: data)
        setValue(data: data)
    }
    
    override init() {
        super.init()
    }
    
    //MARK: - Private Functions
    private func setValue(data : [String : Any]) {
        
        if let value = data[Keys.interestId] as? Int64 {
            interestId = value
        }
        
        if let value = data[Keys.interestName] as? String {
            interestName = value
        }
    
        setData(data: data)
    }
    
}
