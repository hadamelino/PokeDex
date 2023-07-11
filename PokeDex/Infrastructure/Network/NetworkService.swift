//
//  Endpoint.swift
//  PokeDex
//
//  Created by Hada Melino on 06/07/23.
//

import Alamofire
import Foundation
import Reachability

protocol NetworkService {
    var config: NetworkConfigurable { get }
    func get<T: Decodable>(with endpoint: Endpoint, expecting: T.Type, completionHandler: @escaping (Result<T, APIError>) -> Void)
}

enum APIError: Error {
    case invalidURL
    case taskError
    case invalidResponse
    case invalidStatusCode(Int)
    case noData
    case invalidJSON
}

final class APIService: NetworkService {
    
    internal var config: NetworkConfigurable

    private var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = true
        config.allowsExpensiveNetworkAccess = true
        config.waitsForConnectivity = true
        config.timeoutIntervalForRequest = 30
        return URLSession(configuration: config)
    }()
    
    init(with config: NetworkConfigurable) {
        self.config = config
    }
    
    func get<T>(with endpoint: Endpoint, expecting: T.Type, completionHandler: @escaping (Result<T, APIError>) -> Void) where T : Decodable {
        
        let request = try! endpoint.urlRequest(with: config)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                completionHandler(.failure(.taskError))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return completionHandler(.failure(.invalidResponse))
            }
            
            if response.statusCode != 200 {
                completionHandler(.failure(.invalidStatusCode(response.statusCode)))
            }
            
            guard let data = data else {
                return completionHandler(.failure(.noData))
            }
            
            do {
                let list = try JSONDecoder().decode(expecting.self, from: data)
                completionHandler(.success(list))
            } catch {
                completionHandler(.failure(.invalidJSON))
            }
        }
        task.resume()
    }
}

