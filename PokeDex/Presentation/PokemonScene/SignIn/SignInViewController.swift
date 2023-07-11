//
//  LoginViewController.swift
//  PokeDex
//
//  Created by Hada Melino on 08/07/23.
//

import GoogleSignIn
import UIKit

class SignInViewController: UIViewController {
    
    private lazy var googleSignInButton: GIDSignInButton = {
        let signInButton = GIDSignInButton()
        signInButton.style = .wide
        signInButton.colorScheme = .light
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        return signInButton
    }()
    
    private let viewModel: SignInViewModel
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        configureView()
    }
    
    @objc func signInButtonTapped() {
        viewModel.signIn(presenting: self)
    }
    
    private func configureView() {
        view.addSubview(googleSignInButton)
        
        NSLayoutConstraint.activate([
            googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            googleSignInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
    }

}
