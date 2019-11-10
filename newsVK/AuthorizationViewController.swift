//
//  AuthorizationViewController.swift
//  newsVK
//
//  Created by Apple on 10.11.2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit
import WebKit

class AuthorizationViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    let urlString = "https://oauth.vk.com/authorize?client_id=7201688&scope=wall,friends&redirect_uri=http://api.vkontakte.ru/blank.html&display=mobile&response_type=token&revoke=1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        request()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        guard let title = webView.title, let url = webView.url else { return }
        if title == "OAuth Blank" {
            if let token = getQueryStringAccessToken(url: url) {
                UserDefaults.standard.set(token, forKey: "accessToken")
                self.performSegue(withIdentifier: "segueLoginVKtoNews", sender: .none)
            } else {
                request()
            }
        }
    }
    
    //Запрос
    private func request() {

        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
    
    //Вынимаем компонент access_token из url
    private func getQueryStringAccessToken(url: URL) -> String? {
        
        let param = "access_token"
        let urlString = url.absoluteString
        let urlReplace = urlString.replacingOccurrences(of: "#", with: "?")
        
        guard let url = URLComponents(string: urlReplace) else {return nil}
        return url.queryItems?.first(where: { $0.name == param})?.value
    }

    

}
