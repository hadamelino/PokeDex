//
//  AppFlowCoordinator.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import UIKit

final class AppFlowCoordinator {
    
    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(
        navigationController: UINavigationController,
        appDIContainer: AppDIContainer
    ) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        // In App Flow we can check if user needs to login, if yes we would run login flow
        let pokemonSceneDIContainer = appDIContainer.makePokemonScenesDIContainer()
        let flow = pokemonSceneDIContainer.makePokemonListFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
    
    
}
