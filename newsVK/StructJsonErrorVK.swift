//
//  StructJsonErrorVk.swift
//  newsVK
//
//  Created by Apple on 11.11.2019.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation

struct StructJsonErrorVK: Codable {
    let error: ErrorVK
}

struct ErrorVK: Codable {
    let errorCode: Int
    let errorMsg: String
}
