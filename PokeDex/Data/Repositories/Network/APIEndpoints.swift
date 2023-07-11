//
//  APIEndpoints.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import Foundation

struct APIEndpoints {
    
    static func getPokemonList(with pokemonListRequestDTO: PokemonListRequestDTO) -> Endpoint {
        return Endpoint(
            path: "pokemon/",
            method: .get,
            queryParametersEncodable: pokemonListRequestDTO
        )
    }
    
    static func getPokemonSpecies(with pokemonDetailRequestDTO: PokemonDetailRequestDTO) -> Endpoint {
        return Endpoint(path: "pokemon-species/\(pokemonDetailRequestDTO.id)",
                        method: .get
            )
    }
    
    static func getPokemonDetail(with pokemonDetailRequestDTO: PokemonDetailRequestDTO) -> Endpoint {
        return Endpoint(
            path: "pokemon/\(pokemonDetailRequestDTO.id)",
            method: .get
        )
    }
    
    static func getPokemonEvolution(with pokemonEvolutionRequestDTO: PokemonEvolutionRequestDTO) -> Endpoint {
        return Endpoint(path: "evolution-chain/\(pokemonEvolutionRequestDTO.id)",
                        method: .get)
    }
    
}
