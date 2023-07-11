//
//  NetworkConfig.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import Foundation

protocol NetworkConfigurable {
    var baseURL: URL { get }
    var queryParameters: [String: String] { get }
}

struct ApiDataNetworkConfig: NetworkConfigurable {
    let baseURL: URL
    let queryParameters: [String: String]
    
     init(
        baseURL: URL,
        queryParameters: [String: String] = [:]
     ) {
        self.baseURL = baseURL
        self.queryParameters = queryParameters
    }
}
