//
//  DefaultPokemonListRepository.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import Foundation

final class DefaultPokemonListRepository {
    
    private let networkService: NetworkService
    private let cache: PokemonListResponseStorage
    
    init(
        networkService: NetworkService,
        cache: PokemonListResponseStorage
    ) {
        self.networkService = networkService
        self.cache = cache
    }
}

extension DefaultPokemonListRepository: PokemonListRepository {
    func fetchPokemonList(offset: Int, cached: @escaping ([PokemonList]) -> Void, completion: @escaping (Result<[PokemonList], Error>) -> Void) {
        
        let requestDTO = PokemonListRequestDTO(limit: 100, offset: offset)
        let endPoint = APIEndpoints.getPokemonList(with: requestDTO)
    
        cache.getResponse(for: requestDTO) { [weak self] result in
            
            if case let .success(pokemonListDTO) = result {
                if let pokemonListDTO = pokemonListDTO {
                    // If the returned value is empty, try to fetch from the network
                    if pokemonListDTO.isEmpty {
                        self?.networkService.get(with: endPoint, expecting: PokemonResponseDTO.self) { [weak self] result in
                            switch result {
                            case .success(let pokemonList):
                                self?.cache.save(request: requestDTO, response: pokemonList.results)
                                completion(.success(pokemonList.results.map {$0.toDomain()}))
                            case .failure(let error):
                                completion(.failure(error))
                            }
                        }
                    } else {
                        cached(pokemonListDTO.map { $0.toDomain() })
                    }
                }
            }
        }
    }
}

