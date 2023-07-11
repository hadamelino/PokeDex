//
//  PokemonDetailViewModel.swift
//  PokeDex
//
//  Created by Hada Melino on 08/07/23.
//

import Foundation
import Combine

protocol PokemonDetailViewModelInput {
    func viewDidLoad()
}

protocol PokemonDetailViewModelOutput {
    var items: [DetailType] { get }
    var errorMessage: String { get }
}

enum DetailType {
    case stats(PokemonDetail)
    case evolution(PokemonEvolution)
}

final class DefaultPokemonDetailViewModel: PokemonDetailViewModelInput, PokemonDetailViewModelOutput {
  
    @Published var items: [DetailType] = []
    @Published var errorMessage: String = ""
    
    private let fetchPokemonDetailUseCase: FetchPokemonDetailUseCase
    private let pokemonList: PokemonList
    
    init(pokemonList: PokemonList, fetchPokemonDetailUseCase: FetchPokemonDetailUseCase) {
        self.pokemonList = pokemonList
        self.fetchPokemonDetailUseCase = fetchPokemonDetailUseCase
    }
    
    private func fetchDetail() {
        items = []
        fetchPokemonDetailUseCase.execute(requestValue: .init(id: pokemonList.id)) { _, _ in
            
        } completion: { [weak self] result in
            switch result {
            case .success(let pokemonDetails):
                let pokemonStats = pokemonDetails.0
                let pokemonEvolution = pokemonDetails.1
                self?.items.append(.stats(pokemonStats))
                self?.items.append(.evolution(pokemonEvolution))
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }

    }
}

extension DefaultPokemonDetailViewModel {
    func viewDidLoad() {
        fetchDetail()
    }
}
