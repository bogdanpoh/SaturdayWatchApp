//
//  NetworkManager.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 01.04.2022.
//

import Foundation

final class NetworkManager {
    
    struct Endpoint {
        enum HttpMethod: String {
            case get = "GET"
            case post = "POST"
        }
        
        let path: String
        let httpMethod: HttpMethod
        var queryItems: [URLQueryItem]? = nil
        var httpBody: [String: Any]? = nil
        
        var url: URL? {
            var components = URLComponents()
            components.scheme = "http"
            components.host = "192.168.0.101"
            components.port = 5000
            components.path = "/" + path
            components.queryItems = queryItems
            return components.url
        }
        
        var urlRequest: URLRequest? {
            guard let url = url else { return nil }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = httpMethod.rawValue
            if let httpBody = httpBody {
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: httpBody)
                    urlRequest.httpBody = jsonData
                } catch {
                    print("[dev] serelization error")
                }
            }
            return urlRequest
        }
    }
    
    static let shared = NetworkManager()
    
    // MARK: - Initializers
    
    private init() {}
    
    func getSystemInfo(completion: @escaping (Result<SystemInfo, Error>) -> Void) {
        let endpoint = Endpoint(path: "system", httpMethod: .get)
        
        makeRequest(endpoint) { (response: SystemInfo?, error: Error?) in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let response = response else { return }
            completion(.success(response))
        }
    }
    
    func getShortcuts(completion: @escaping (Result<ShortcutsResponse, Error>) -> Void) {
        let endpoint = Endpoint(path: "shortcuts", httpMethod: .get)
        
        makeRequest(endpoint) { (response: ShortcutsResponse?, error: Error?) in
            if let error = error {
                completion(.failure(error))
            }
            
            guard let response = response else { return }
            completion(.success(response))
        }
    }
    
    func postVolume(_ value: String) {
        var endpoint = Endpoint(path: "sound", httpMethod: .post)
        endpoint.httpBody = ["volume": value]
        
        makeRequest(endpoint) { (response: ServerResponse?, error: Error?) in
            if let error = error {
                print("[dev] \(error)")
            }
            
            guard let response = response else { return }
            
            print("[dev] message: \(response.message)")
        }
    }
    
    func postBrightness(_ value: Int) {
        var endpoint = Endpoint(path: "brightness", httpMethod: .post)
        endpoint.httpBody = ["brightness_level": value]
        
        makeRequest(endpoint) { (response: ServerResponse?, error: Error?) in
            if let error = error {
                print("[dev] \(error)")
            }
            
            guard let response = response else { return }
            
            print("[dev] message: \(response.message)")
        }
    }
    
    func postMedia(_ key: String) {
        var endpoint = Endpoint(path: "media", httpMethod: .post)
        endpoint.httpBody = ["key": key]
        
        makeRequest(endpoint) { (response: ServerResponse?, error: Error?) in
            if let error = error {
                print("[dev] \(error)")
            }
            
            guard let response = response else { return }
            
            print("[dev] message: \(response.message)")
        }
    }
    
    func postShortcut(_ shortcut: String) {
        var endpoint = Endpoint(path: "shortcut", httpMethod: .post)
        endpoint.httpBody = ["shortcut": shortcut]
        
        makeRequest(endpoint) { (response: ServerResponse?, error: Error?) in
            if let error = error {
                print("[dev] \(error)")
            }
            
            guard let response = response else { return }
            
            print("[dev] message: \(response.message)")
        }
    }
    
    func postTest() {
        var endpoint = Endpoint(path: "", httpMethod: .post)
        endpoint.httpBody =  [
            "name": "Bohdan"
        ]
        
        makeRequest(endpoint) { (response: String?, error: Error?) in
            if let error = error {
                print("[dev] \(error)")
            }
            
            guard let response = response else { return }
            
            print("[dev] \(response)")
        }
    }
    
    // MARK: - Private
    
    let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
}

// MARK: - Private Methods

private extension NetworkManager {
    
    func makeRequest<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (T?, _ error: Error?) -> Void) {
        guard let request = endpoint.urlRequest else { return }
        
        print("[dev] \(request.url?.absoluteString ?? "bad url") - \(endpoint.httpMethod.rawValue)")
        
        URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard error == nil else {
                completion(nil, error!)
                return
            }
            
            guard let data = data else { return }
            
            self?.fetchData(data: data, completion: completion)
        }.resume()
    }
    
    func fetchData<T: Decodable>(data: Data, completion: @escaping (T?, _ error: Error?) -> Void) {
        do {
            let response = try jsonDecoder.decode(T.self, from: data)
            completion(response, nil)
        } catch {
            completion(nil, error)
        }
    }
    
}
