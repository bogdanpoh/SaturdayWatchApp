//
//  NetworkManager.swift
//  Saturday WatchKit Extension
//
//  Created by Bohdan Pokhidnia on 01.04.2022.
//

import Foundation

protocol EndPointProtocol {
    var path: String { get }
    var httpMethod: NetworkManager.HttpMethod { get }
    var httpBody: [String: Any]? { get set }
}

final class NetworkManager {
    
    enum HttpMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    struct Endpoint {
        let scheme: String = "http"
        let host: String = "192.168.0.101"
        let port: Int = 5000
        let path: String
        let httpMethod: HttpMethod
        var queryItems: [URLQueryItem]? = nil
        var httpBody: [String: Any]? = nil
        
        var url: URL? {
            var components = URLComponents()
            components.scheme = scheme
            components.host = host
            components.port = port
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
    
    func request<T: Decodable>(type: EndPointProtocol, completion: @escaping (T?, _ error: Error?) -> Void) {
        var endpoint = Endpoint(path: type.path, httpMethod: type.httpMethod)
        endpoint.httpBody = type.httpBody
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
    
    // MARK: - Private
    
    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()
    
}

// MARK: - Private Methods

private extension NetworkManager {
    
    func fetchData<T: Decodable>(data: Data, completion: @escaping (T?, _ error: Error?) -> Void) {
        do {
            let response = try jsonDecoder.decode(T.self, from: data)
            completion(response, nil)
        } catch {
            completion(nil, error)
        }
    }
    
}
