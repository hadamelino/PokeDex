//
//  PokemonListStorage.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import Foundation

protocol PokemonListResponseStorage {
    func getResponse(
        for requestDTO: PokemonListRequestDTO,
        completion: @escaping (Result<[PokemonListDTO]?, Error>) -> Void
    )
    
    func save(
        request requestDTO: PokemonListRequestDTO,
        response: [PokemonListDTO]
    )
}
