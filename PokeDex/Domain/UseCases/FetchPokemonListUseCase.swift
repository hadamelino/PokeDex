//
//  FetchPokemonListUseCase.swift
//  PokeDex
//
//  Created by Hada Melino on 06/07/23.
//

import Foundation

protocol FetchPokemonListUseCase {
    func execute(
        requestValue: FetchPokemonListUseCaseRequestValue,
        cached: @escaping ([PokemonList]) -> Void,
        completion: @escaping (Result<[PokemonList], Error>) -> Void
    )
}

final class DefaultFetchPokemonListUseCase: FetchPokemonListUseCase {
    
    private let pokemonListRepository: PokemonListRepository
    
    init(pokemonListRepository: PokemonListRepository) {
        self.pokemonListRepository = pokemonListRepository
    }
    
    func execute(requestValue: FetchPokemonListUseCaseRequestValue, cached: @escaping ([PokemonList]) -> Void, completion: @escaping (Result<[PokemonList], Error>) -> Void) {
        pokemonListRepository.fetchPokemonList(
            offset: requestValue.offset,
            cached: cached,
            completion: completion
        )
    }
}

struct FetchPokemonListUseCaseRequestValue {
    let offset: Int
}
