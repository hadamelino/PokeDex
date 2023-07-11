//
//  LoginUseCase.swift
//  PokeDex
//
//  Created by Hada Melino on 08/07/23.
//

import Foundation
import UIKit

protocol SignInUseCase {
    func execute(presenting viewController: UIViewController, isSuccess: @escaping (Bool) -> Void)
}

final class DefaultSignInUseCase: SignInUseCase {
    
    private let authenticationService: AuthenticationService
    
    init(authenticationService: AuthenticationService) {
        self.authenticationService = authenticationService
    }
    
    func execute(presenting viewController: UIViewController, isSuccess: @escaping (Bool) -> Void) {
        authenticationService.signIn(presenting: viewController, isSuccess: isSuccess)
    }
}
