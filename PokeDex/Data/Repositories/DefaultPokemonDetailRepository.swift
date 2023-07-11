//
//  DefaultPokemonDetailRepository.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import Foundation

final class DefaultPokemonDetailRepository {
    
    let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }
}

extension DefaultPokemonDetailRepository: PokemonDetailRepository {
    
    func fetchPokemonDetail(id: Int, cached: @escaping (PokemonDetail, PokemonEvolution) -> Void, completion: @escaping (Result<(PokemonDetail, PokemonEvolution), Error>) -> Void) {
        
        
        let statsEndpoint = APIEndpoints.getPokemonDetail(
            with: .init(id: id)
        )
        
        let speciesEndpoint = APIEndpoints.getPokemonSpecies(
            with: .init(id: id)
        )
        
        networkService.get(with: speciesEndpoint, expecting: PokemonSpeciesResponseDTO.self) { [weak self] result in
            switch result {
            case .success(let pokemonSpecies):
                let evolutionEndpoint = APIEndpoints.getPokemonEvolution(
                    with: .init(id: pokemonSpecies.getEvolutionChainID())
                )
                self?.networkService.get(with: statsEndpoint, expecting: PokemonDetailDTO.self) { [weak self] result in
                    switch result {
                    case .success(let pokemonDetail):
                        self?.networkService.get(with: evolutionEndpoint, expecting: PokemonEvolutionResponseDTO.self) { result in
                            switch result {
                            case .success(let pokemonEvolution):
                                let combinedData = (pokemonDetail.toDomain(), pokemonEvolution.chain.toDomain())
                                completion(.success(combinedData))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        
        
        
    }
}
