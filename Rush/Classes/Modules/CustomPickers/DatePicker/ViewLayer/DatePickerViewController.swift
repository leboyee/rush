//
//  DatePickerViewController.swift
//  wolf
//
//  Created by Kamal Mittal on 16/07/18.
//  Copyright © 2018 Suresh Jagnani. All rights reserved.
//

import UIKit
@objc protocol DatePickerDelegate {
    @objc func selectedDate(_ date: Date)
}

class DatePickerViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewConstraint: NSLayoutConstraint!
    
    var selectedData = ""
    var presenter = DatePickerPresenter()
    weak var pickerDelegate: DatePickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.containerViewConstraint.constant = 0
            UIView.animate(withDuration: 0.2) {
                self.containerView.layoutIfNeeded()
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - setup
    func setup() {
        setupPresenter()
        //picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    @IBAction func doneButtonAction() {
        pickerDelegate?.selectedDate(datePicker.date)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func handleTapGesture(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            self.containerViewConstraint.constant = 262
            UIView.animate(withDuration: 0.1, animations: {
                self.view.layoutIfNeeded()
            }, completion: { _ in
                self.dismiss(animated: false, completion: nil)
            })
        }
    }
}

// MARK: - Input View Handler (Or Presenter Output)
extension DatePickerViewController {
    func setupPresenter() {
        presenter.updateTitle = { [weak self] (title) in
            guard let unsafe = self else { return }
            unsafe.titleLabel.text = title
        }
        
        presenter.updatePickerMode = { [weak self] (mode) in
            guard let unsafe = self else { return }
            unsafe.datePicker.datePickerMode = mode
        }
        
        presenter.updateMinDate = { [weak self] (date) in
            guard let unsafe = self else { return }
            unsafe.datePicker.minimumDate = date
        }
       
        presenter.updateMaxDate = { [weak self] (date) in
            guard let unsafe = self else { return }
            unsafe.datePicker.maximumDate = date
        }
        
        presenter.updateCurrentDate = { [weak self] (date) in
            guard let unsafe = self else { return }
            unsafe.datePicker.date = date
        }
        
        presenter.viewIsReady()
    }
}
