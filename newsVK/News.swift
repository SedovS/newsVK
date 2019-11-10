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
    public var photo: UIImage?
    
    init(text: String, urlPhoto: String){
        self.text = text
        self.urlPhoto = urlPhoto
        self.photo = nil
    }
}

var globalArrayNews = [News]()
