//
//  News.swift
//  newsVK
//
//  Created by Apple on 10.11.2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class News {
    public let text: String
    public let urlPhoto: String
    
    init(text: String, urlPhoto: String){
        self.text = text
        self.urlPhoto = urlPhoto
    }
}

var globalArrayNews = [News]()
var globaldictionaryCasheImege = NSCache<NSString, UIImage>()
