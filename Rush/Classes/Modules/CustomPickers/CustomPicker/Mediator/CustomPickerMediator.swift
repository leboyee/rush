//
//  CustomPickerMediator.swift
//  wolf
//
//  Created by Suresh Jagnani on 02/07/18.
//  Copyright © 2018 Suresh Jagnani. All rights reserved.
//

import UIKit

class CustomPickerMediator: NSObject {

    weak var pickerView : UIPickerView?
    var selectedRow: Int = 0

    var numberOfComponents: (() -> Int)?
    var numberOfRowsInComponent: ((_ component : Int) -> Int)?
    var fillPicker: ((_ component : Int, _ row : Int) -> String)?
    var selected: ((_ component : Int, _ row : Int) -> Void)?
    
    //MARK: - Life Cycle
    deinit {
        pickerView = nil
    }
    
    // MARK: - Other Functions
    func setupMediator(pickerView: UIPickerView) {
        self.pickerView = pickerView
        self.pickerView?.delegate = self
        self.pickerView?.dataSource = self
    }
}

extension CustomPickerMediator: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents?() ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return numberOfRowsInComponent?(component) ?? 0
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return fillPicker?(component, row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selected?(component, row)
    }
    
}
