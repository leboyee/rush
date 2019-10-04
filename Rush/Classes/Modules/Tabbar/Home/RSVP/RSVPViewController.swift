//
//  RSVPViewController.swift
//  Rush
//
//  Created by kamal on 13/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
class RSVPViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var joinBottomSpaceConstraint: NSLayoutConstraint!

    var event: Event?
    var action = EventAction.join
    var answers = [RSVPAnswer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
       removeKeyboardObservers()
    }
}

// MARK: - Setup and Privacy
extension RSVPViewController: UIGestureRecognizerDelegate {
    
    private func setup() {
        view.backgroundColor = UIColor.bgBlack
        tabBarController?.tabBar.isHidden = true

        //left gesture when back button hide or replaced
        if let gesture = navigationController?.interactivePopGestureRecognizer {
            gesture.delegate = self
        }
        
        addKeyboardObservers()
        
        setupTableView()
        //loadAllData()
    }
}

// MARK: - Action
extension RSVPViewController {

    @IBAction func joinButtonAction() {
        view.endEditing(true)
        joinEvent()
    }
}

// MARK: - Register / Unregister Observers
extension RSVPViewController {
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleKeyboardDidChangeState(_:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }

    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc
    func handleKeyboardDidChangeState(_ notification: Notification) {
        
        guard let keyboardStartFrameInScreenCoords = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else { return }
        guard !keyboardStartFrameInScreenCoords.isEmpty || UIDevice.current.userInterfaceIdiom != .pad else {
            // WORKAROUND for what seems to be a bug in iPad's keyboard handling in iOS 11: we receive an extra spurious frame change
            // notification when undocking the keyboard, with a zero starting frame and an incorrect end frame. The workaround is to
            // ignore this notification.
            return
        }

        guard let keyboardEndFrameInScreenCoords = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let keyboardEndFrame = view.convert(keyboardEndFrameInScreenCoords, from: view.window)
        var contentInset = tableView.contentInset
        contentInset.bottom = keyboardEndFrame.height
        tableView.contentInset = contentInset
    }
}

// MARK: - Other
extension RSVPViewController {

    func toggleJoinButton(isEnbled: Bool) {
        joinButton.isEnabled = isEnbled
    }
    
    func joinSuccessfully(isFirstTime: Bool) {
        if isFirstTime {
           performSegue(withIdentifier: Segues.eventJoinedPopup, sender: nil)
        }
        /// Reload event details
        if let navigationController = navigationController {
            navigationController.viewControllers.forEach({ (vc) in
            if vc.isKind(of: EventDetailViewController.self) {
                (vc as? EventDetailViewController)?.type = .joined
                (vc as? EventDetailViewController)?.loadAllData()
               }
            })
        }
        navigationController?.popViewController(animated: false)
    }
    
    func showMessage(message: String) {
        Utils.alert(message: message)
    }
}

// MARK: - Navigation
extension RSVPViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.eventJoinedPopup {
            let vc = segue.destination as? EventJoinedPopupViewController
            vc?.event = event
        }
    }
}
