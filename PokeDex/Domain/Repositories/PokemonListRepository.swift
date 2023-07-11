//
//  PokemonRepository.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import Foundation

protocol PokemonListRepository {
    func fetchPokemonList(
        offset: Int,
        cached: @escaping ([PokemonList]) -> Void,
        completion: @escaping (Result<[PokemonList], Error>) -> Void
    )
}
