//
//  InstaWebViewMediates.swift
//  Rush
//
//  Created by Suresh Jagnani on 13/09/19.
//  Copyright © 2019 Messapps. All rights reserved.
//

import UIKit
import WebKit

extension InstaWebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        
        if checkRequestForCallbackURL(request: navigationAction.request) {
            decisionHandler(.allow)
        } else {
            decisionHandler(.cancel)
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Utils.hideSpinner()
        
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Utils.hideSpinner()
        Utils.alert(message: error.localizedDescription)
    }

}
