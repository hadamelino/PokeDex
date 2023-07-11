//
//  PokemonDetailRepository.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import Foundation

protocol PokemonDetailRepository {
    func fetchPokemonDetail(
        id: Int,
        cached: @escaping (PokemonDetail, PokemonEvolution) -> Void,
        completion: @escaping (Result<(PokemonDetail, PokemonEvolution), Error>) -> Void
    )
}
