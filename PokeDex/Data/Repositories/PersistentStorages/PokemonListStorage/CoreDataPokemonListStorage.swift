//
//  CoreDataPokemonListStorage.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import CoreData
import Foundation

final class CoreDataPokemonListStorage {
    
    private let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    private func fetchRequest(for requestDTO: PokemonListRequestDTO) -> NSFetchRequest<PokemonListEntity> {
        let request: NSFetchRequest = PokemonListEntity.fetchRequest()
        let lowerBoundPredicate: NSPredicate = NSPredicate(format: "id > %d", requestDTO.offset)
        let upperBoundPredicate: NSPredicate = NSPredicate(format: "id <= %d", requestDTO.offset + requestDTO.limit)
        let compoundPredicate: NSCompoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [lowerBoundPredicate, upperBoundPredicate])
        let idSort: NSSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        request.sortDescriptors = [idSort]
        request.predicate = compoundPredicate
        return request
    }
    
    private func deleteResponse(
        for requestDTO: PokemonListRequestDTO,
        in context: NSManagedObjectContext
    ) {
        let request = fetchRequest(for: requestDTO)
        
        do {
            let results = try context.fetch(request)
            results.forEach { pokemonList in
                context.delete(pokemonList)
            }
        } catch {
            print("Failed to delete response \(error)")
        }
    }
    
}

extension CoreDataPokemonListStorage: PokemonListResponseStorage {
    
    func getResponse(
        for requestDTO: PokemonListRequestDTO,
        completion: @escaping (Result<[PokemonListDTO]?, Error>) -> Void
    ) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = self.fetchRequest(for: requestDTO)
                let requestEntity = try context.fetch(fetchRequest)
                
                completion(.success(requestEntity.map { $0.toDTO() }))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func save(
        request requestDTO: PokemonListRequestDTO,
        response pokemonListDTO: [PokemonListDTO]
    ) {
        coreDataStorage.performBackgroundTask { context in
            do {
                self.deleteResponse(
                    for: requestDTO,
                    in: context
                )
                
                pokemonListDTO.forEach { pokemon in
                    pokemon.toEntity(in: context)
                }
                try context.save()
            } catch {
                print("Failed to save context \(error)")
            }
        }
    }
}
