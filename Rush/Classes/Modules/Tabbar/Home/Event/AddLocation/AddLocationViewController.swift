//
//  CreateEventViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MapKit
import GooglePlaces
import GoogleMapsBase

protocol AddEventLocationDelegate: class {
    func addEventLocationData(_ address: String, latitude: Double, longitude: Double)
}

class AddLocationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gestureView: UIView!
    @IBOutlet weak var locationEntryTextField: UITextField!
    @IBOutlet weak var curentAdressLabel: UILabel!
    @IBOutlet weak var topLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var handlerImageView: UIImageView!
    @IBOutlet weak var topSearchTextLayoutConstraint: NSLayoutConstraint!

    var completerResults: [MKLocalSearchCompletion] = []
    var mapItemToPresent: MKMapItem?
    let searchCompleter = MKLocalSearchCompleter()
    let locationManager = CLLocationManager()
    var usersCurrentLocation: CLLocation?
    var isRegister = false
    var searchList = [String]()
    var placesClient = GMSPlacesClient.shared()

    weak var delegate: AddEventLocationDelegate?

    // MARK: - View-Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = UIColor.clear
        navigationController?.navigationBar.isTranslucent = true
        locationEntryTextField.becomeFirstResponder()
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        IQKeyboardManager.shared.enableAutoToolbar = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        
        // Stop location update once we have it.
        locationManager.stopUpdatingLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.locationEntryTextField.becomeFirstResponder()
    }
 
    // MARK: - Other function
    func setup() {
        
        self.searchCompleter.delegate = self
        if isRegister == true {
            self.searchCompleter.filterType = .locationsOnly
            self.topLayoutConstraint.constant = 0
            self.topSearchTextLayoutConstraint.constant = 0
            self.handlerImageView.isHidden = true
        }
        self.locationEntryTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        // Ask for Authorisation from the User.
        locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        }
        
        setupUI()
    }
    
    func setupUI() {
        let panGesture: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(gesture:)))
        gestureView.addGestureRecognizer(panGesture)

        // Setup tableview
        setupTableView()
    
    }
}

// MARK: - Actions
extension AddLocationViewController {
    
    @IBAction func clearUserEntryForLocationPressed() {
     self.locationEntryTextField.text = ""
        self.completerResults.removeAll()
        self.tableView.reloadData()
    }
    
    @IBAction func userPressedChooseCurentLocation() {
        let placemark = MKPlacemark(coordinate: self.usersCurrentLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0),
                                    addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = curentAdressLabel.text
        self.mapItemToPresent = mapItem
        self.delegate?.addEventLocationData(curentAdressLabel.text ?? "", latitude: self.usersCurrentLocation?.coordinate.latitude ?? 0.0, longitude: self.usersCurrentLocation?.coordinate.longitude ?? 0.0)
        self.dismiss(animated: true, completion: nil)
        print("selected map item is : \(String(describing: self.mapItemToPresent))")
    }
}

// MARK: - Other function
extension AddLocationViewController {
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        self.view.endEditing(true)
        let velocity = gesture.velocity(in: self.view)
        if velocity.y > 0 {
            self.dismiss(animated: true, completion: nil)
        }
    
    }

}
// MARK: - Mediator
extension AddLocationViewController {
    func selectedCell() {
        self.view.endEditing(true)
        self.delegate?.addEventLocationData(curentAdressLabel.text ?? "", latitude: self.usersCurrentLocation?.coordinate.latitude ?? 0.0, longitude: self.usersCurrentLocation?.coordinate.longitude ?? 0.0)
        if isRegister == true {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - Navigation
extension AddLocationViewController {

}
