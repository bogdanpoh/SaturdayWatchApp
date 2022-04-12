//
//  PostShortcut.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 12.04.2022.
//

import Foundation

class PostShortcut: EndPointProtocol {
    
    var path: String { "shortcut" }
    var httpMethod: NetworkManager.HttpMethod { .post }
    var httpBody: [String : Any]?
    
    init(shortcut: String) {
        httpBody = ["shortcut": shortcut]
    }
    
}
