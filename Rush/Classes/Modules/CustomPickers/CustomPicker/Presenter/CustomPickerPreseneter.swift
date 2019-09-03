//
//  CustomPickerPreseneter.swift
//  wolf
//
//  Created by Suresh Jagnani on 02/07/18.
//  Copyright © 2018 Suresh Jagnani. All rights reserved.
//

import UIKit

enum PickerType : String {
    case country    = "Country"
    case countryCode    = "Country Code"
    case industry   = "Industry"
    case cityState  = "City, State"
    case relation   = "Relation"
    case new        = "New password"
    case gender        = "Gender"
    case docType        = "Select Identification Document"

}

class CustomPickerPreseneter: NSObject {
    //MARK: - Defines handler and varibales
    weak var mediator : CustomPickerMediator?
    var pickerDataList : [String]?
    var selectedValue : String = ""
    var type : PickerType = .country
    var currencyList : [String: Any]?
    var countryCode : [[String: Any]] = []
    var selectedIndex: Int = 0
    
    var updateTitle: ((_ title : String) -> Void)?


    //MARK: - Life Cycle
    deinit {
        mediator = nil
    }
    
    //MARK: - View Output Functions
    func viewIsReady() {
        loadCountryJson()
        pickData()
        setupDependencies()
    }
}

//MARK: - Mediator Output Handler or setup dependencies (TableView)
extension CustomPickerPreseneter {
    
    func setupDependencies() {
        
        mediator?.numberOfComponents = { () in
            return 1
        }
        
        mediator?.numberOfRowsInComponent = { [weak self] (component) in
            guard let self_ = self else { return 0 }
            return self_.pickerDataList?.count ?? 0
        }
        
        mediator?.fillPicker = {  [weak self] (component, row) in
            guard let self_ = self else { return "" }
            if let value = self_.pickerDataList?[row] {
                return value
            }
            return ""
        }
        
        mediator?.selected = {  [weak self] (component, row) in
            guard let self_ = self else { return }
            if let value = self_.pickerDataList?[row] {
                self_.selectedValue = value
            }
        }
      
    }
}

extension CustomPickerPreseneter {
    func pickData() {
        var title = ""
        if type == .country {
            title =  type.rawValue
            let countryNameStringArray = countryCode
                .map({ $0["name"]  as! String})
            pickerDataList = countryNameStringArray
        }
        if type == .relation {
            title =  ""
            pickerDataList = ["Single","Taken","Prefer not to say"]
        }
        if type == .gender {
            title =  ""
            pickerDataList = ["Male","Female"]
        }
        updateTitle?(title)
    }
  
    func loadCountryJson() {
        if let path = Bundle.main.path(forResource: "RushCountryCode", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [[String: Any]] {
                    countryCode = jsonResult
                }
            } catch { }
        }
    }

}



