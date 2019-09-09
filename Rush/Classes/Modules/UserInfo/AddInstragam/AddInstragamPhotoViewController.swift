//
//  AddInstragamPhotoViewController.swift
//  Rush
//
//  Created by Suresh Jagnani on 22/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import WebKit

let instragramRedirectUrl = "http://localhost"
class AddInstragamPhotoViewController: CustomViewController {

    @IBOutlet weak var bgImageView: CustomBackgoundImageView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var connectButton: CustomButton!
    @IBOutlet weak var wkWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        connectButton.layer.cornerRadius = 8.0
        connectButton.clipsToBounds = true
        wkWebView.isHidden = true
        setCustomNavigationBarView()
    }
    
    // Custom navigation Title View
    func setCustomNavigationBarView() {
        
        let gotProfileButton = UIButton(frame: CGRect.init(x: 0, y: 0, width: 128, height: 36))
        gotProfileButton.setImage(UIImage(named: "goToProfileButton"), for: .normal)
        gotProfileButton.addTarget(self, action: #selector(gotProfileButtonAction), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-arrow"), style: .plain, target: self, action: #selector(backButtonAction))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: gotProfileButton)
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        
    }
}

// MARK: - Other Function
extension AddInstragamPhotoViewController {

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
        }
    }

    func tokenSuccess() {
        connectInstragramAlert()
    }
   
}

// MARK: - Actions
extension AddInstragamPhotoViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
    
     @objc func gotProfileButtonAction() {
        AppDelegate.shared?.moveToTabbarWithoutRegister()
        //Utils.alert(message: "In Development")
    }

    @IBAction func connectButtonAction() {
        wkWebView.isHidden = false
        //let instagramHooks = "instagram://"
        //let instagramUrl = URL(string: instagramHooks)
//        if UIApplication.shared.canOpenURL(instagramUrl!) {
//            UIApplication.shared.open(instagramUrl!, options: [:], completionHandler: nil)
//            //[self.docFile presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
//        } else {
            let authURL = String(format: "%@?client_id=2972f8c6aec34238932d142d1ef38665&redirect_uri=%@&response_type=token&DEBUG=True", arguments: [instagramAuthUrl, instragramRedirectUrl])
            let urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
            wkWebView.navigationDelegate = self
            wkWebView.load(urlRequest)
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(instragramRedirectUrl) {
           // let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            wkWebView.isHidden = true
            print(String(requestURLString.suffix(requestURLString.count - 31)))
            uploadAccesstokenInsta(token: String(requestURLString.suffix(requestURLString.count - 31)))
            return false
        }
        return true
    }
    
}

// MARK: - Navigation
extension AddInstragamPhotoViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Segues.inviteContactSegue {
            if let vc = segue.destination as? ContactsListViewController {
                vc.isFromRegister = true
            }
        }
    }
}
