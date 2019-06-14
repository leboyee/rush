//
//  Utils.swift
//  Rush
//
//  Created by iChirag on 06/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//


import UIKit
import SVProgressHUD
import AVKit
import Photos


class Utils: NSObject {
    static let shared = Utils()
}


//MARK: - Alerts
extension Utils {
    
    class func notReadyAlert() {
        let alert = UIAlertController(title: "In development!", message: "This component isn't ready", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        action.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(action)
        alert.show()
    }
    
    class func alert(message: String, title: String? = "") {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            action.setValue(UIColor.black, forKey: "titleTextColor")
            alert.addAction(action)
            alert.show()
        }
    }
    
    class func alert(message: String? = nil, title: String? = nil, titleImage : UIImage? = nil, buttons : [String] , cancel : String? = nil, destructive : String? = nil, type : UIAlertController.Style = .alert, handler :@escaping (Int)->()) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: type)
            //Set Image with Title
            if titleImage != nil {
                //Create Attachment
                let imageAttachment =  NSTextAttachment()
                imageAttachment.image = titleImage
                let imageOffsetY: CGFloat = -15.0
                imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: imageAttachment.image!.size.width, height: imageAttachment.image!.size.height)
                let attachmentString = NSAttributedString(attachment: imageAttachment)
                
                let completeText = NSMutableAttributedString(string: "")
                completeText.append(attachmentString)
                
                let text = "\n" + (title ?? "")
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 0.7
                paragraphStyle.alignment = .center
                paragraphStyle.lineHeightMultiple = 1.4
                let titleImage = NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0), NSAttributedString.Key.paragraphStyle : paragraphStyle])
                completeText.append(titleImage)
                alert.setValue(completeText, forKey: "attributedTitle")
            }
            
            for button in buttons {
                let action = UIAlertAction(title: button, style: .default) { (action) in
                    if let index = buttons.firstIndex(of: action.title!) {
                        DispatchQueue.main.async {
                            handler(index)
                        }
                    }
                }
                alert.addAction(action)
                action.setValue(UIColor.black, forKey: "titleTextColor")
            }
            
            if let destructiveText = destructive {
                let action = UIAlertAction(title: destructiveText, style: .destructive) { (_) in
                    handler(buttons.count)
                }
                alert.addAction(action)
                action.setValue(UIColor.black, forKey: "titleTextColor")
            }
            
            if let cancelText = cancel {
                let action = UIAlertAction(title: cancelText, style: .cancel) { (_) in
                    let index = buttons.count + (destructive != nil ? 1 : 0)
                    handler(index)
                }
                alert.addAction(action)
                action.setValue(UIColor.black, forKey: "titleTextColor")
            }
            
            alert.show()
        }
    }
}

//MARK: -  CAMERA
extension Utils {
    enum VideoAuthorizationStatus {
        case justDenied
        case alreadyDenied
        case restricted
        case justAuthorized
        case alreadyAuthorized
    }
    
    class func authorizeVideo(completion: ((VideoAuthorizationStatus) -> Void)?) {
        self.authorize(mediaType: AVMediaType.video, completion: completion)
    }
    
    private class func authorize(mediaType: AVMediaType, completion: ((VideoAuthorizationStatus) -> Void)?) {
        let status = AVCaptureDevice.authorizationStatus(for: mediaType)
        switch status {
        case .authorized:
            completion?(.alreadyAuthorized)
        case .denied:
            completion?(.alreadyDenied)
        case .restricted:
            completion?(.restricted)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: mediaType, completionHandler: { (granted) in
                DispatchQueue.main.async {
                    if(granted) {
                        completion?(.justAuthorized)
                    }
                    else {
                        completion?(.justDenied)
                    }
                }
            })
        }
    }
}
//MARK: -  PHOTO LIBRARY
extension  Utils {
    
    enum PhotoLibraryAuthorizationStatus {
        case justDenied
        case alreadyDenied
        case restricted
        case justAuthorized
        case alreadyAuthorized
    }
    
    class func authorizePhoto(completion: ((PhotoLibraryAuthorizationStatus) -> Void)?) {
        self.authorize(completion: completion)
    }
    
    private class func authorize(completion: ((PhotoLibraryAuthorizationStatus) -> Void)?) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion?(.alreadyAuthorized)
        case .denied:
            completion?(.alreadyDenied)
        case .restricted:
            completion?(.restricted)
        case .notDetermined:
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    //self.openCameraOrLibrary(type: .photoLibrary)
                    completion?(.justAuthorized)
                }
                else {
                    completion?(.justDenied)
                }
            })
        }
    }
    
    class func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Camera Access",
            message: "Camera access is required to make full use of this app.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        
        alert.show()
    }
    
    
    class func photoLibraryPermissionAlert() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Photo Album",
            message: "Permission is required to add photo.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Settings", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        
        alert.show()
    }
    
    
}

//MARK: - UserDefault Functions
extension Utils {
    class func saveDataToUserDefault(_ data : Any, _ key : String) {
        let archived = NSKeyedArchiver.archivedData(withRootObject: data)
        UserDefaults.standard.set(archived, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func getDataFromUserDefault(_ key : String) -> Any? {
        guard let archived =  UserDefaults.standard.object(forKey: key) else {
            return nil
        }
        return NSKeyedUnarchiver.unarchiveObject(with: archived as! Data);
    }
    
    class func removeDataFromUserDefault(_ key : String) {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
}

//MARK: - Spinner
extension Utils {
    class func showSpinner() {
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.setDefaultAnimationType(.native)
            SVProgressHUD.show()
        }
    }
    
    class func showSpinner(message: String) {
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.setDefaultAnimationType(.native)
            SVProgressHUD.show(withStatus: message)
        }
    }
    class func hideSpinner() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
}

//MARK: - Local
extension Utils {
    class func locale(for fullCountryName : String) -> String? {
        for localeCode in NSLocale.isoCountryCodes {
            let identifier = NSLocale(localeIdentifier: "en_US")
            var countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
            countryName = countryName?.replacingOccurrences(of: " - ", with: "-")
            if fullCountryName.lowercased() == countryName?.lowercased() {
                return localeCode
            }
        }
        return nil
    }
}


//MARK: - Others
extension Utils {
    
    class var isHasSafeArea: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets != .zero
        }
        return false
    }
    
    class var navigationHeigh: CGFloat {
        let statusBar = UIApplication.shared.statusBarFrame.size.height
        let navBar = CGFloat(44)
        return (navBar + statusBar)
    }
    
    class func roundCorners(view: UIView,corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        view.layer.mask = mask
    }
    
    class func getNavigationBarTitle(title: String, textColor: UIColor) -> UIView {
        let customView = UIView(frame: CGRect(x: 48, y: 0, width: screenWidth - 48, height: 44))
        let label = UILabel(frame: CGRect(x: 0, y: 2, width: screenWidth - 48, height: 30))
        label.text = title
        label.font = UIFont.DisplayBold(sz: 24)
        label.textColor = textColor
        customView.addSubview(label)
        return customView
    }
    
    // Static Arrays
    class func chooseLevelArray() -> [String] {
        return ["High school", "Undergraduate", "Graduate", "Alumni", "Professor"]
    }
    
    class func chooseYearArray() -> [String] {
        return ["Freshman", "Sophomore", "Junior", "Senior"]
    }
    
}

//MARK: - Alert Extension
private var kAlertControllerWindow = "kAlertControllerWindow"
extension UIAlertController {
    
    var alertWindow: UIWindow? {
        get {
            return objc_getAssociatedObject(self, &kAlertControllerWindow) as? UIWindow
        }
        set {
            objc_setAssociatedObject(self, &kAlertControllerWindow, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    func show() {
        show(animated: true)
    }
    
    func show(animated: Bool) {
        alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow?.rootViewController = UIViewController()
        alertWindow?.windowLevel = UIWindow.Level.alert + 1
        alertWindow?.makeKeyAndVisible()
        alertWindow?.rootViewController?.present(self, animated: animated, completion: nil)
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        alertWindow?.isHidden = true
        alertWindow = nil
    }
}
