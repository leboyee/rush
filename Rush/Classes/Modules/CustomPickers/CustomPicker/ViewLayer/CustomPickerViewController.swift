//
//  CustomPickerViewController.swift
//  wolf
//
//  Created by Suresh Jagnani on 02/07/18.
//  Copyright © 2018 Suresh Jagnani. All rights reserved.
//

import UIKit

@objc protocol CustomPickerDelegate {
    
    // Picker
    @objc func selectedValue(data: String, type: String)
    @objc optional func selectedCountryValue(countryName: String, countryCode: String)

}

class CustomPickerViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewConstraint: NSLayoutConstraint!

    var selectedData = ""
    var dataArray = [String]()
    var presenter = CustomPickerPreseneter()
    var mediator  = CustomPickerMediator()
    weak var pickerDelegate: CustomPickerDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setup()
        setupMediator()
        setupPresenter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.containerViewConstraint.constant = 0
        UIView.animate(withDuration: 0.2) {
            self.containerView.layoutIfNeeded()
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - setup
    func setup() {
        
    }
    
    func setupMediator() {
        mediator.setupMediator(pickerView: pickerView)
        setupMediatorHandlers()
        
    }
    
    func setupPresenter() {
        presenter.mediator = mediator
        setupPresenterHandlers()
        presenter.viewIsReady()
        //pickerView.selectRow(presenter.selectedValue, inComponent: 0, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func doneButtonAction() {
        if presenter.selectedValue == "" {
            presenter.selectedValue = presenter.pickerDataList![0]
        }
        if presenter.type == .country {
            var countryCodeValue = ""
            if let categoryId = presenter.countryCode.firstIndex(where: { $0["name"] as? String ?? "" == presenter.selectedValue }) {
                countryCodeValue = presenter.countryCode[categoryId]["dial_code"] as? String ?? ""
            }
            
            pickerDelegate?.selectedCountryValue!(countryName: presenter.selectedValue, countryCode: countryCodeValue)
        } else {
            pickerDelegate.selectedValue(data: presenter.selectedValue, type: presenter.type.rawValue)
        }
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func handleTapGesture(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            self.containerViewConstraint.constant = 262
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded()
            }, completion: { (_) in
                self.dismiss(animated: false, completion: nil)
            })
        }
    }
}

// MARK: - Input View Handler (Or Presenter Output)
extension CustomPickerViewController {
    func setupPresenterHandlers() {
        presenter.updateTitle = { [weak self] (title) in
            guard let unsafe = self else { return }
            unsafe.titleLabel.text = title
        }
    }
}

// MARK: - Input View Handler (Or Mediator Output)
extension CustomPickerViewController {
    
    func setupMediatorHandlers() {
        
    }
}
