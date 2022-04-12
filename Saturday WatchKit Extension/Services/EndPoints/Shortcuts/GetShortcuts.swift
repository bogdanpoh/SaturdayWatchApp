//
//  GetShortcuts.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 12.04.2022.
//

import Foundation

class GetShortcuts: EndPointProtocol {
    
    var path: String { "shortcuts" }
    var httpMethod: NetworkManager.HttpMethod { .get }
    var httpBody: [String : Any]?
    
}
