//
//  PokemonEvolutionCell.swift
//  PokeDex
//
//  Created by Hada Melino on 08/07/23.
//

import Foundation
import Kingfisher
import UIKit

class PokemonEvolutionCell: UITableViewCell {
    
    static let id: String = "EvolutionCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Evolutions"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var evolutionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var parentHorizontalStack: UIStackView = {
        let hStack = UIStackView()
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        hStack.distribution = .equalSpacing
        return hStack
    }()
    
    private var arrangedImageViews = [UIImageView]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configureView(with pokemonEvolution: PokemonEvolution) {
        
        arrangedImageViews.forEach { imageView in
            parentHorizontalStack.removeArrangedSubview(imageView)
            imageView.removeFromSuperview()
        }
        arrangedImageViews = []
        
        var curr = pokemonEvolution
    
        while !curr.evolveTo.isEmpty {
            stackImageView(imageURL: curr.species.imageURL)
            curr = curr.evolveTo.first!
        }
        
        stackImageView(imageURL: curr.species.imageURL)
    }
    
    private func buildView() {
        contentView.addSubview(parentHorizontalStack)
        contentView.addSubview(evolutionLabel)
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            parentHorizontalStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            parentHorizontalStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            parentHorizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            parentHorizontalStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        ])
        
    }
    
    private func stackImageView(imageURL: String) {
        let imageView = createImageViewEvolution()
        arrangedImageViews.append(imageView)
        parentHorizontalStack.addArrangedSubview(imageView)
        configureImageView(for: imageView, with: imageURL)
    }
    
    private func configureImageView(for imageView: UIImageView, with url: String) {
        if let url = URL(string: Constant.imageBaseUrl + extractID(from: url) + ".png") {
            imageView.image = nil
            imageView.kf.setImage(with: url)
        }
    }
    
    private func extractID(from urlString: String) -> String {
        let urlComponents = urlString.split(separator: "/")
        return String(urlComponents.last ?? "1")
    }
    
    private func createImageViewEvolution() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
