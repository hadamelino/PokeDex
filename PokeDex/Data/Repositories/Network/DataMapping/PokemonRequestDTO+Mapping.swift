//
//  PokemonRequestDTO+Mapping.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import Foundation

struct PokemonListRequestDTO: Encodable {
    var limit: Int
    var offset: Int
}

struct PokemonDetailRequestDTO: Encodable {
    var id: Int
}

struct PokemonEvolutionRequestDTO: Encodable {
    var id: Int
}


