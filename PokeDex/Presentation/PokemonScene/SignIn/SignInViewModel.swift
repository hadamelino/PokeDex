//
//  File.swift
//  PokeDex
//
//  Created by Hada Melino on 08/07/23.
//

import Foundation
import UIKit

struct SignInViewModelActions {
    let showPokemonList: () -> Void
}

final class SignInViewModel {
    
    private let actions: SignInViewModelActions?
    private let signInUseCase: SignInUseCase
    
    init(actions: SignInViewModelActions? = nil, signInUseCase: SignInUseCase) {
        self.actions = actions
        self.signInUseCase = signInUseCase
    }
    
    internal func signIn(presenting viewController: UIViewController) {
        signInUseCase.execute(presenting: viewController) { [weak self] isSuccess in
            if isSuccess {
                self?.actions?.showPokemonList()
            }
        }
    }
}
