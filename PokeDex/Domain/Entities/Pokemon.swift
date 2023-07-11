//
//  Pokemon.swift
//  PokeDex
//
//  Created by Hada Melino on 06/07/23.
//

import Foundation

struct PokemonDetail {
    
    struct Stats {
        let baseStat: Int
        let stat: [String:String]
    }
    
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let stats: [Stats]
}

struct PokemonList {
    let id: Int
    let name: String
    let imageURL: String
}

struct PokemonEvolution {
    let species: PokemonList
    let evolveTo: [PokemonEvolution]
}
