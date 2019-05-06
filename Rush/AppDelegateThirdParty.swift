//
//  AppDelegateThirdParty.swift
//  Rush
//
//  Created by iChirag on 06/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import Bugsee
import IQKeyboardManagerSwift

extension AppDelegate {
    func addThirdPartySDK() {
        
        let infoDict = Bundle.main.infoDictionary!
        
        //Add bugsee
        let instabugEnabled = infoDict["EnableBugsee"] as! String
        if instabugEnabled == "YES" {
            if let bugseeKey = infoDict["BugseeKey"] as? String {
                Bugsee.launch(token : bugseeKey)
            }
        }
        
        
        //KeyboardManager
        setupIQKeyboardManager()
        
    }
    
    func setupIQKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
    }
}
