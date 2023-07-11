//
//  PokemonListEntity+Mapping.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import CoreData
import Foundation

extension PokemonListDTO {
    func toEntity(in context: NSManagedObjectContext) {
        let entity: PokemonListEntity = .init(context: context)
        entity.name = name
        entity.url = url
        entity.id = Int64(id)
    }
}

extension PokemonListEntity {
    func toDTO() -> PokemonListDTO {
        return PokemonListDTO(
            name: name ?? "",
            url: url ?? ""
        )
    }
}
