//
//  FetchPokemonDetailUseCase.swift
//  PokeDex
//
//  Created by Hada Melino on 06/07/23.
//

import Foundation

protocol FetchPokemonDetailUseCase {
    func execute(
        requestValue: FetchPokemonDetailUseCaseRequestValue,
        cached: @escaping (PokemonDetail, PokemonEvolution) -> Void,
        completion: @escaping (Result<(PokemonDetail, PokemonEvolution), Error>) -> Void
    )
}

final class DefaultFetchPokemonDetailUseCase: FetchPokemonDetailUseCase {
    
    private let pokemonDetailRepository: PokemonDetailRepository
    
    init(pokemonDetailRepository: PokemonDetailRepository) {
        self.pokemonDetailRepository = pokemonDetailRepository
    }

    func execute(requestValue: FetchPokemonDetailUseCaseRequestValue, cached: @escaping (PokemonDetail, PokemonEvolution) -> Void, completion: @escaping (Result<(PokemonDetail, PokemonEvolution), Error>) -> Void) {
        pokemonDetailRepository.fetchPokemonDetail(id: requestValue.id, cached: cached, completion: completion)
    }
    
}

struct FetchPokemonDetailUseCaseRequestValue {
    let id: Int
}
