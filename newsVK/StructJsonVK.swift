//
//  Model.swift
//  newsVK
//
//  Created by Apple on 10.11.2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct StructJsonVK: Codable  {
    let response: Response
}

struct Response: Codable{
    let items : [Items]
    let nextFrom: String
}

struct Items: Codable {
    let text: String? //Есть посты без текста
    let attachments: [Attachments]? //Есть посты без Attachments (например репосты)
}

struct Attachments: Codable {
    let type: String
    let photo: Photo? //если гифка то поля photo нет
}

struct Photo: Codable {
    let sizes: [Sizes]
}

struct Sizes: Codable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}
