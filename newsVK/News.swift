//
//  News.swift
//  newsVK
//
//  Created by Apple on 10.11.2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

class News {
    let text: String
    let urlPhoto: String
    let width: Int
    let height: Int
    
    init(text: String, urlPhoto: String, width: Int, height: Int ){
        self.text = text
        self.urlPhoto = urlPhoto
        self.width = width
        self.height = height
    }
}

var globalArrayNews = [News]()
var globaldictionaryCasheImege = NSCache<NSString, UIImage>()
