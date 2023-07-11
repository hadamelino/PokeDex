//
//  AppDIContainer.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import Foundation


final class AppDIContainer {
    
    lazy var apiService: NetworkService = {
        let config = ApiDataNetworkConfig(
            baseURL: URL(string: "https://pokeapi.co/api/v2/")!
        )
        let apiService = APIService(with: config)
        return apiService
    }()
    
    
    func makePokemonScenesDIContainer() -> PokemonScenesDIContainer {
        let dependencies = PokemonScenesDIContainer.Dependencies(
            apiService: apiService,
            authenticationService: GoogleAuthentication()
        )
        return PokemonScenesDIContainer(dependencies: dependencies)
    }
}
