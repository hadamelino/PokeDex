//
//  PokemonCollectionViewCell.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import UIKit
import Kingfisher

class PokemonCollectionViewCell: UICollectionViewCell {
    
    static let id: String = "PokemonCell"
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        buildView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func buildView() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(imageView)
        
        layer.cornerRadius = 16
        
        NSLayoutConstraint.activate([
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        ])

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor)
        ])
    }
    
    internal func configure(item: PokemonList) {
        nameLabel.text = item.name
        configureImageView(with: item.imageURL)
    }
    
    private func configureImageView(with url: String) {
        if let url = URL(string: Constant.imageBaseUrl + extractID(from: url) + ".png") {
            imageView.kf.setImage(with: url)
        }
    }
    
    private func extractID(from urlString: String) -> String {
        let urlComponents = urlString.split(separator: "/")
        return String(urlComponents.last ?? "1")
    }
    
}
