//
//  SocketManager.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 27.03.2022.
//

import Foundation
import Network

protocol SocketManagerProtocol {
    func connect(completion: ((NWConnection.State) -> Void)?)
    func send(_ content: String, completion: ((SocketError?) -> Void)?)
    func receive(completion: @escaping ((Result<Data, SocketError>) -> Void))
}

final class SocketManager {
    
    var connection: NWConnection
    
    init(host: NWEndpoint.Host, port: NWEndpoint.Port, parameters: NWParameters = .udp) {
        connection = NWConnection(host: host, port: port, using: parameters)
    }
    
}

// MARK: - SocketManagerProtocol

extension SocketManager: SocketManagerProtocol {
    
    func connect(completion: ((NWConnection.State) -> Void)? = nil) {
        connection.stateUpdateHandler = completion
        connection.start(queue: .global())
    }
    
    func send(_ content: String, completion: ((SocketError?) -> Void)? = nil) {
        let contentData = content.data(using: .utf8)
        
        connection.send(content: contentData, completion: .contentProcessed({ error in
            guard let error = error else { return }
            
            completion?(.socket(error))
        }))
    }
    
    func receive(completion: @escaping ((Result<Data, SocketError>) -> Void)) {
        connection.receiveMessage { completeContent, contentContext, isComplete, error in
            guard isComplete else {
                completion(.failure(.message("Receive is not completion")))
                return
            }
            
            guard let data = completeContent else {
                completion(.failure(.message("Data is empty")))
                return
            }
            
            completion(.success(data))
        }
    }
    
}
