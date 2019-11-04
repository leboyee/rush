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
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

}

extension WebViewFileViewController {
    
    private func setup() {
        
        /// Set background color
        view.backgroundColor = UIColor.bgBlack
        
        /// Load requires file
        var text = ""
        var path = ""
        switch type {
        case .policy:
            text = Text.dataPolicy
            path = Bundle.main.path(forResource: "terms", ofType: "html") ?? ""
        case .term:
            text = Text.termsConditions
            path = Bundle.main.path(forResource: "terms", ofType: "html") ?? ""
        }
        
        guard path.isNotEmpty else { return }
        let url = URL(fileURLWithPath: path)
        webview.loadRequest(URLRequest(url: url))
        
        /// Title
        let customTitleView = Utils.getNavigationBarTitle(title: text, textColor: UIColor.white)
        navigationItem.titleView = customTitleView
    }
    
}
