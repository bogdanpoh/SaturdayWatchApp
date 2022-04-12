//
//  GetApplications.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 12.04.2022.
//

import Foundation

class GetApplications: EndPointProtocol {
    
    var path: String { "applications" }
    var httpMethod: NetworkManager.HttpMethod { .get }
    var httpBody: [String : Any]?
    
}
