//
//  Endpoint.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import Foundation

enum HTTPMethodType: String {
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

struct Endpoint: Requestable {
    let path: String
    let method: HTTPMethodType
    let queryParametersEncodable: Encodable?
    let queryParameters: [String: Any]

    init(path: String,
         method: HTTPMethodType,
         queryParametersEncodable: Encodable? = nil,
         queryParameters: [String: Any] = [:]
    ) {
        self.path = path
        self.method = method
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
    }
}

protocol Requestable {
    var path: String { get }
    var method: HTTPMethodType { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
}

enum RequestGenerationError: Error {
    case components
}

extension Requestable {
    
    func url(with config: NetworkConfigurable) throws -> URL {

        let baseURL = config.baseURL.absoluteString.last != "/"
        ? config.baseURL.absoluteString + "/"
        : config.baseURL.absoluteString
        let endpoint = baseURL.appending(path)
        
        guard var urlComponents = URLComponents(
            string: endpoint
        ) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()

        let queryParameters = try queryParametersEncodable?.toDictionary() ?? self.queryParameters
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        return urlRequest
    }
}

private extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String : Any]
    }
}
