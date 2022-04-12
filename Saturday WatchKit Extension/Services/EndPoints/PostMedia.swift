//
//  PostMedia.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 12.04.2022.
//

import Foundation

class PostMedia: EndPointProtocol {
    
    var path: String { "media" }
    var httpMethod: NetworkManager.HttpMethod { .post }
    var httpBody: [String : Any]?
    
    init(key: String) {
        httpBody = ["key": key]
    }
    
}
