//
//  PokemonScenesDIContainer.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import UIKit

final class PokemonScenesDIContainer: PokemonFlowCoordinatorDependencies {
 
    struct Dependencies {
        let apiService: NetworkService
        let authenticationService: AuthenticationService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
    lazy var pokemonListResponseCache: PokemonListResponseStorage = CoreDataPokemonListStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makePokemonListFlowCoordinator(navigationController: UINavigationController) -> PokemonListFlowCoordinator {
        PokemonListFlowCoordinator(
            navigationController: navigationController,
            dependencies: self
        )
    }
    
    // MARK: - Use Cases
    func makeSignInUseCase() -> SignInUseCase {
        DefaultSignInUseCase(authenticationService: dependencies.authenticationService)
    }
    
    func makeFetchPokemonListUseCase() -> FetchPokemonListUseCase {
        DefaultFetchPokemonListUseCase(pokemonListRepository: makePokemonListRepository())
    }
    
    func makeFetchPokemonDetailUseCase() -> FetchPokemonDetailUseCase {
        DefaultFetchPokemonDetailUseCase(pokemonDetailRepository: makePokemonDetailRepository())
    }
    
    // MARK: - Repositories
    func makePokemonListRepository() -> PokemonListRepository {
        DefaultPokemonListRepository(
            networkService: dependencies.apiService,
            cache: pokemonListResponseCache)
    }
    
    func makePokemonDetailRepository() -> PokemonDetailRepository {
        DefaultPokemonDetailRepository(
            networkService: dependencies.apiService
        )
    }
    
    // MARK: - Sign In
    func makeSignInViewController(actions: SignInViewModelActions) -> SignInViewController {
        SignInViewController(viewModel: makeSignInViewModel(actions: actions))
    }
    
    func makeSignInViewModel(actions: SignInViewModelActions) -> SignInViewModel {
        SignInViewModel(actions: actions, signInUseCase: makeSignInUseCase())
    }
    
    // MARK: - Pokemon List
    func makePokemonListViewController(actions: PokemonListViewModelActions) -> PokemonListViewController {
        let viewModel = makePokemonListViewModel(actions: actions)
        return PokemonListViewController(viewModel: viewModel)
    }
    
    func makePokemonListViewModel(actions: PokemonListViewModelActions) -> DefaultPokemonListViewModel {
        DefaultPokemonListViewModel(
            fetchPokemonListUseCase: makeFetchPokemonListUseCase(),
            actions: actions
        )
    }
    
    // MARK: - Pokemon Detail
    func makePokemonDetailViewController(from pokemonList: PokemonList) -> PokemonDetailTableViewController {
        let viewModel = makePokemonDetailViewModel(from: pokemonList)
        return PokemonDetailTableViewController(viewModel: viewModel)
    }
    
    func makePokemonDetailViewModel(from pokemonList: PokemonList) -> DefaultPokemonDetailViewModel {
        DefaultPokemonDetailViewModel(
            pokemonList: pokemonList,
            fetchPokemonDetailUseCase: makeFetchPokemonDetailUseCase())
    }
    
}
