//
//  AddInviteViewLogics.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/07/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import FacebookShare
import FacebookCore

extension AddInviteViewController {
}

// MARK: - Manage Interator or API's Calling
extension AddInviteViewController {
    
}

extension AddInviteViewController: SharingDelegate {
    func sharer(_ sharer: Sharing, didCompleteWithResults results: [String: Any]) {
        
    }
    
    func sharer(_ sharer: Sharing, didFailWithError error: Error) {
        print(error)
    }
    
    func sharerDidCancel(_ sharer: Sharing) {
        
    }
}
