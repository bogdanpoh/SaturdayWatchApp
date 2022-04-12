//
//  PostBrightness.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 12.04.2022.
//

import Foundation

class PostBrightness: EndPointProtocol {
    
    var path: String { "brightness" }
    var httpMethod: NetworkManager.HttpMethod { .post }
    var httpBody: [String : Any]?
    
    init(value: Int) {
        httpBody = ["brightness_level": value]
    }
    
}
