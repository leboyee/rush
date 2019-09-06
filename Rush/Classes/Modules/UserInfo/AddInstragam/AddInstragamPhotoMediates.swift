//
//  AddInviteViewMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 10/05/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import WebKit

extension AddInstragamPhotoViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if checkRequestForCallbackURL(request: navigationAction.request) {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
    }
}
