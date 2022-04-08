//
//  SocketError.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 27.03.2022.
//

import Foundation
import Network

enum SocketError: Error {
    case message(String?), socket(NWError), other(Error)
    
    var localizedDescription: String {
        switch self {
        case .message(let error):
            return error ?? ""
            
        case .socket(let error):
            return error.localizedDescription
            
        case .other(let error):
            return error.localizedDescription
        }
    }
}
