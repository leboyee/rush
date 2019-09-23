//
//  InstaWebViewViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 13/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import WebKit

let instragramRedirectUrl = "http://localhost"
class InstaWebViewViewController: CustomViewController {

    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var wkWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func viewWillLayoutSubviews() {
        if UIDevice.current.screenType.rawValue == UIDevice.ScreenType.iPhones5.rawValue {
        }
    }
    
    // MARK: - Setup
    func setup() {
        setupUI()
    }
    
    func setupUI() {

        // Set Custom part of Class
        Utils.showSpinner()
        setCustomNavigationBarView()
        connectButtonAction()
    }
    
    // Custom navigation Title View
    func setCustomNavigationBarView() {
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
    }
}

// MARK: - Other Function
extension InstaWebViewViewController {

    func connectInstragramAlert() {
        let alert = UIAlertController(title: "\n\n\n\(Message.instagramTitle)", message: Message.instagramMessage, preferredStyle: .alert)
        let imgViewTitle = UIImageView(frame: CGRect(x: 100, y: 25, width: 64, height: 64))
        imgViewTitle.image = #imageLiteral(resourceName: "instagram")
        alert.view.tintColor = UIColor.instaPopupBgColor
        alert.view.addSubview(imgViewTitle)
        self.present(alert, animated: true, completion: nil)
        self.dismissAlert(alert: alert)
    }
    
    func dismissAlert(alert: UIAlertController) {
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
            AppDelegate.shared?.moveToTabbarWithoutRegister()
        }
    }

    func tokenSuccess() {
        connectInstragramAlert()
    }
   
}

// MARK: - Actions
extension InstaWebViewViewController {
    @objc func backButtonAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func connectButtonAction() {
        wkWebView.isHidden = false
        let authURL = String(format: "%@?client_id=2972f8c6aec34238932d142d1ef38665&redirect_uri=%@&response_type=token&DEBUG=True", arguments: [instagramAuthUrl, instragramRedirectUrl])
        let urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
        wkWebView.navigationDelegate = self
        wkWebView.load(urlRequest)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(instragramRedirectUrl) {
            wkWebView.isHidden = true
            print(String(requestURLString.suffix(requestURLString.count - 31)))
            uploadAccesstokenInsta(token: String(requestURLString.suffix(requestURLString.count - 31)))
            return false
        }
        return true
    }
    
}
