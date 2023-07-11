//
//  PokemonResponseDTO+Mapping.swift
//  PokeDex
//
//  Created by Hada Melino on 06/07/23.
//

import Foundation

// MARK: - Pokemon Results
struct PokemonResponseDTO: Decodable {
    let results: [PokemonListDTO]
}

struct PokemonListDTO: Decodable {
    let name: String
    let url: String
    var id: Int {
        getID()
    }
    
    func getID() -> Int {
        let urlComponents = url.split(separator: "/")
        return Int(urlComponents.last ?? "1") ?? 0
    }
}

// MARK: - Pokemon Detail
struct PokemonDetailDTO: Decodable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let stats: [StatsModelDTO]
}

struct StatsModelDTO: Decodable {
    let base_stat: Int
    let effort: Int
    let stat: [String:String]
}

// MARK: - Pokemon Evolution
struct PokemonEvolutionResponseDTO: Decodable {
    let id: Int
    let chain: PokemonEvolutionDTO
}

struct PokemonEvolutionDTO: Decodable {
    let species: PokemonListDTO
    let evolves_to: [PokemonEvolutionDTO]
}

// MARK: - Pokemon Species
struct PokemonSpeciesResponseDTO: Decodable {
    let evolution_chain: [String:String]
    
    func getEvolutionChainID() -> Int {
        guard let url = evolution_chain["url"] else { return 0 }
        let urlComponents = url.split(separator: "/")
        return Int(urlComponents.last ?? "0") ?? 0
    }
}

extension PokemonListDTO {
    func toDomain() -> PokemonList {
        return PokemonList(id: id, name: name, imageURL: url)
    }
}

extension PokemonDetailDTO {
    func toDomain() -> PokemonDetail {
        return PokemonDetail(id: id,
                             name: name,
                             height: height,
                             weight: weight,
                             stats: stats.map { PokemonDetail.Stats(baseStat: $0.base_stat, stat: $0.stat) }
        )
    }
}

extension PokemonEvolutionDTO {
    func toDomain() -> PokemonEvolution {
        PokemonEvolution(
            species: species.toDomain(),
            evolveTo: evolves_to.map { $0.toDomain() })
    }
}
