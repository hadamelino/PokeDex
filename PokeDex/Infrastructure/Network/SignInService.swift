//
//  LoginService.swift
//  PokeDex
//
//  Created by Hada Melino on 08/07/23.
//

import FirebaseCore
import FirebaseAuth
import Foundation
import GoogleSignIn
import UIKit

protocol AuthenticationService {
    func signIn(presenting viewController: UIViewController, isSuccess: @escaping (Bool) -> Void)
    func signOut()
}

final class GoogleAuthentication: AuthenticationService {
    
    func signIn(presenting viewController: UIViewController, isSuccess: @escaping (Bool) -> Void) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
            guard error == nil else {
                isSuccess(false)
                return
            }
            isSuccess(true)
        }
    }
    
    func signOut() {
        
    }
    
}
