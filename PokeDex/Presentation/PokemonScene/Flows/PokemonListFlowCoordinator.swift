//
//  PokemonListFlowCoordinator.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import UIKit

protocol PokemonFlowCoordinatorDependencies {
    func makeSignInViewController(actions: SignInViewModelActions) -> SignInViewController
    func makePokemonListViewController(actions: PokemonListViewModelActions) -> PokemonListViewController
    func makePokemonDetailViewController(from pokemonList: PokemonList) -> PokemonDetailTableViewController
}

final class PokemonListFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependencies: PokemonFlowCoordinatorDependencies
    
    private weak var signInVC: SignInViewController?
    
    init(navigationController: UINavigationController,
        dependencies: PokemonFlowCoordinatorDependencies
    ) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        
        let vc = dependencies.makeSignInViewController(actions: SignInViewModelActions(showPokemonList: showPokemonList))
        navigationController?.pushViewController(vc, animated: false)

        signInVC = vc
        
    }
    
    private func showPokemonList() {
        let actions = PokemonListViewModelActions(showPokemonDetail: showPokemonDetail)
        let vc = dependencies.makePokemonListViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func showPokemonDetail(from pokemonList: PokemonList) {
        let vc = dependencies.makePokemonDetailViewController(from: pokemonList)
        navigationController?.pushViewController(vc, animated: true)
    }
}
