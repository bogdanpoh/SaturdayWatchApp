//
//  PostApplication.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 12.04.2022.
//

import Foundation

class PostApplication: EndPointProtocol {
    
    var path: String { "applications" }
    var httpMethod: NetworkManager.HttpMethod { .post }
    var httpBody: [String : Any]?
    
    init(application: String) {
        httpBody = ["application": application]
    }
    
}
