//
//  WebViewFileViewController.swift
//  Rush
//
//  Created by kamal on 09/08/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit

enum WebFile {
    case policy
    case term
}

class WebViewFileViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    var type: WebFile = .policy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}

extension WebViewFileViewController {
    
    private func setup() {
        
        /// Set background color
        view.backgroundColor = UIColor.bgBlack
        //webview.layer.cornerRadius = topViewRadius
        //webview.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //webview.clipsToBounds = true
        
        /// Load requires file
        var text = ""
        var path = ""
        switch type {
        case .policy:
            text = Text.dataPolicy
            path = Bundle.main.path(forResource: "PrivacyPolicy", ofType: "pdf") ?? ""
        case .term:
            text = Text.termsConditions
            path = Bundle.main.path(forResource: "terms", ofType: "html") ?? ""
        }
        
        guard path.isNotEmpty else { return }
        let url = URL(fileURLWithPath: path)
        webview.loadRequest(URLRequest(url: url))
        
        /// Title
        let backbutton = UIButton()
        backbutton.setImage(UIImage(named: "back-arrow"), for: .normal)
        backbutton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
        label.text = text
        label.font = UIFont.displayBold(sz: 24)
        label.textColor = UIColor.white
        
        let stackview = UIStackView.init(arrangedSubviews: [backbutton, label])
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 8
        let titleBarItem = UIBarButtonItem(customView: stackview)
        
        navigationItem.leftBarButtonItem = titleBarItem
        navigationItem.hidesBackButton = true
    }
}

// MARK: - Actions
extension WebViewFileViewController {
    @objc func backButtonAction() {
        navigationController?.popViewController(animated: false)
    }
}
