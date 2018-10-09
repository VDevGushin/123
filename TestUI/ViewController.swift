//
//  ViewController.swift
//  TestUI
//
//  Created by Vladislav Gushin on 05/10/2018.
//  Copyright © 2018 Vladislav Gushin. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        self.webView.navigationDelegate = self
        self.searchBar.showsBookmarkButton = true
        self.searchBar.showsCancelButton = true
    }
}



extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let url = URL(string: "https://uchebnik.mos.ru/exam/player/control_test/163181/1")
        let req = URLRequest(url: url!)
        let pool = WKProcessPool()
        let configuration = WKWebViewConfiguration()
        configuration.processPool = pool
        let coockie = [
            ("request_method", "GET"),
            ("auth_token", "5170f02937a4cf6768a055548dc64def"),
            ("profile_id", "5788399"),
            ("user_id", "5610771"),
            ("clientType", "iOS"),
        ]

        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        self.setCookie(coockie) {
            self.webView.load(req)
        }
        configuration.processPool = pool

        keyboardDismiss()
    }

    func setCookie(_ with: [(key: String, value: String)], completionHandler: @escaping () -> Void) {
        guard with.count > 0 else {
            completionHandler()
            return
        }

        var dict = with
        let element = dict.removeFirst()

        setCookie(key: element.key, value: element.value) {
            self.setCookie(dict, completionHandler: completionHandler)
        }
    }

    func setCookie(key: String, value: Any, completionHandler: @escaping () -> Void) {
        // let expTime = TimeInterval(60 * 60 * 24 * 365)
        let expTime = TimeInterval(60 * 1)
        //let expTime = TimeInterval(1)
        let cookieProps: [HTTPCookiePropertyKey: Any] = [
            HTTPCookiePropertyKey.domain: "uchebnik.mos.ru",
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: key,
            HTTPCookiePropertyKey.value: value,
            HTTPCookiePropertyKey.secure: "TRUE",
            HTTPCookiePropertyKey.expires: NSDate(timeIntervalSinceNow: expTime)
        ]

        guard let cookie = HTTPCookie(properties: cookieProps) else {
            completionHandler()
            return
        }
        
        self.webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie) {
            completionHandler()
        }

        //HTTPCookieStorage.shared.setCookie(cookie)
        //completionHandler()
//        WKWebsiteDataStore.default().httpCookieStore.setCookie(cookie) {
//            completionHandler()
//        }
    }

    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        keyboardDismiss()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        keyboardDismiss()
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(WKNavigationActionPolicy.allow)
    }

    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(WKNavigationResponsePolicy.allow)
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("test")
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("test")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print("test")
    }


    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {

    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("test")
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print("test")
    }


    /*! @abstract Invoked when the web view needs to respond to an authentication challenge.
     @param webView The web view that received the authentication challenge.
     @param challenge The authentication challenge.
     @param completionHandler The completion handler you must invoke to respond to the challenge. The
     disposition argument is one of the constants of the enumerated type
     NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
     the credential argument is the credential to use, or nil to indicate continuing without a
     credential.
     @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
     */
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        print("test")
        completionHandler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
    }


    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print("test")
    }
}

extension ViewController {
    func keyboardDismiss() {
        searchBar.resignFirstResponder()
    }
}


extension WKWebView {

    var httpCookieStore: WKHTTPCookieStore {
        return WKWebsiteDataStore.default().httpCookieStore
    }

    func getCookies(for domain: String? = nil, completion: @escaping ([String: Any]) -> ()) {
        var cookieDict = [String: AnyObject]()
        httpCookieStore.getAllCookies { (cookies) in
            for cookie in cookies {
                if let domain = domain {
                    if cookie.domain.contains(domain) {
                        cookieDict[cookie.name] = cookie.properties as AnyObject?
                    }
                } else {
                    cookieDict[cookie.name] = cookie.properties as AnyObject?
                }
            }
            completion(cookieDict)
        }

    }
}
