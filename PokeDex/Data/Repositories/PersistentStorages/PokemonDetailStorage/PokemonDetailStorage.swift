//
//  PokemonDetailStorage.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import Foundation

protocol PokemonDetailStorage {
    func getResponse(
        completion: @escaping (Result<PokemonDetailDTO?, Error>) -> Void
    )
    func save(response: PokemonResponseDTO)
}
