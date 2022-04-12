//
//  GetSystemInfo.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 12.04.2022.
//

import Foundation

class GetSystemInfo: EndPointProtocol {
    
    var path: String { "system" }
    var httpMethod: NetworkManager.HttpMethod { .get }
    var httpBody: [String : Any]?
    
}
