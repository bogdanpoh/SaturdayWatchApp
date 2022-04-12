//
//  PostVolume.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 12.04.2022.
//

import Foundation

class PostVolume: EndPointProtocol {
    
    var path: String { "sound" }
    var httpMethod: NetworkManager.HttpMethod { .post }
    var httpBody: [String : Any]?
    
    init(value: String) {
        httpBody = ["volume": value]
    }
    
}
