//
//  PokemonListViewModel.swift
//  PokeDex
//
//  Created by Hada Melino on 06/07/23.
//

import Foundation
import Reachability

struct PokemonListViewModelActions {
    let showPokemonDetail: (PokemonList) -> Void
}

protocol PokemonListViewModelInput {
    func viewDidLoad()
    func viewWillAppear()
    func didLoadNextPage()
    func didSelectItem(at indexPath: IndexPath)
    func didTryRefreshForConnection()
}

protocol PokemonListViewModelOutput {
    var items: [PokemonList] { get }
    var error: String { get }
    var isLoading: Bool { get }
}

class DefaultPokemonListViewModel {
    
    // Handle error when no internet
    // Handle Cache while request
    
    private let fetchPokemonListUseCase: FetchPokemonListUseCase
    private let actions: PokemonListViewModelActions
    let reachability = try! Reachability()
    
    private(set) var currentOffset: Int = 0
    private let limit: Int = 100
 
    init(
        fetchPokemonListUseCase: FetchPokemonListUseCase,
        actions: PokemonListViewModelActions
    ) {
        self.fetchPokemonListUseCase = fetchPokemonListUseCase
        self.actions = actions
        fetchPokemon()
    }
    
    // MARK: Output
    @Published var items: [PokemonList] = []
    @Published var error: String = ""
    @Published var isLoading: Bool = false
    
    private func appendPokemonList(_ pokemonList: [PokemonList]) {
        items.append(contentsOf: pokemonList)
    }
    
    private func fetchPokemon() {
        isLoading = true
        fetchPokemonListUseCase.execute(requestValue: .init(offset: currentOffset)) { [weak self] pokemonList in
            self?.isLoading = false
            self?.appendPokemonList(pokemonList)
        } completion: { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let pokemonList):
                self?.appendPokemonList(pokemonList)
            case .failure(let error):
                print("Failed to get network data \(error)")
            }
        }
    }
 
    private func addNetworkListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    @objc func reachabilityChanged(note: Notification) {

      let reachability = note.object as! Reachability

      switch reachability.connection {
      case .wifi:
          print("Reachable via WiFi")
      case .cellular:
          print("Reachable via Cellular")
      case .unavailable:
          error = "Network not reachable"
      default:
          break
      }
    }

}

extension DefaultPokemonListViewModel: PokemonListViewModelInput, PokemonListViewModelOutput {
    func didTryRefreshForConnection() {
        fetchPokemon()
    }
    
    func viewWillAppear() {
        addNetworkListener()
    }
    
    func viewDidLoad() {
        
    }
    
    func didLoadNextPage() {
        currentOffset += limit
        fetchPokemon()
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        actions.showPokemonDetail(items[indexPath.row])
    }

}
