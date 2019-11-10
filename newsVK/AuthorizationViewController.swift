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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let _ = UserDefaults.standard.string(forKey: "accessToken") else {
            request()
            return
        }
        segue()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        guard let title = webView.title, let url = webView.url else { return }
        switch title {
        case "OAuth Blank":
            if let token = getQueryStringAccessToken(url: url) {
                UserDefaults.standard.set(token, forKey: "accessToken")
                segue()
            } else {
                request()
            }
        case "Новости":
            request()
        default:
            break
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

    //Переход к NewsTableVC
    private func segue() {
        self.performSegue(withIdentifier: "segueLoginVKtoNews", sender: .none)

    }

}
