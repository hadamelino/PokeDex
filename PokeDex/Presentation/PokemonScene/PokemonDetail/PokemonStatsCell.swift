//
//  PokemonDetailCell.swift
//  PokeDex
//
//  Created by Hada Melino on 08/07/23.
//

import Foundation
import UIKit

class PokemonStatsCell: UITableViewCell {
    
    static let id: String = "DetailCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var pokemonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var attackStatLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var hpStatLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var defenseStatLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var speedStatLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.tintColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private lazy var parentHorizontalStack: UIStackView = {
        let hStack = UIStackView()
        hStack.translatesAutoresizingMaskIntoConstraints = false
        hStack.axis = .horizontal
        return hStack
    }()
    
    private lazy var detailVerticalStack: UIStackView = {
        let vStack = UIStackView()
        vStack.translatesAutoresizingMaskIntoConstraints = false
        vStack.axis = .vertical
        return vStack
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        buildView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func configureView(with pokemonStats: PokemonDetail) {
        configureImageView(with: pokemonStats.id)
        titleLabel.text = "\(pokemonStats.name)'s Stats"
        heightLabel.text = "Height: \(pokemonStats.height)"
        weightLabel.text = "Weight: \(pokemonStats.weight)"
        
        let statsDict = getStatDict(from: pokemonStats.stats)
        attackStatLabel.text = "Attack: \(statsDict["attack"] ?? 0)"
        hpStatLabel.text = "HP: \(statsDict["hp"] ?? 0)"
        defenseStatLabel.text = "Defense: \(statsDict["defense"] ?? 0)"
        speedStatLabel.text = "Speed: \(statsDict["speed"] ?? 0)"
    }
    
    private func configureImageView(with id: Int) {
        if let url = URL(string: "\(Constant.imageBaseUrl)\(id).png") {
            pokemonImage.kf.setImage(with: url)
        }
    }
    
    private func getStatDict(from stats: [PokemonDetail.Stats]) -> [String: Int] {
        
        var statsDict = [String: Int]()
        
        stats.forEach { stat in
            if let statName = stat.stat["name"] {
                statsDict[statName] = stat.baseStat
            }
        }
        
        return statsDict
    }
    
    private func buildView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(parentHorizontalStack)
        
        let parentViews = [
            pokemonImage, detailVerticalStack
        ]
        
        let vStackViews = [
            heightLabel,
            weightLabel,
            attackStatLabel,
            hpStatLabel,
            defenseStatLabel,
            speedStatLabel,
        ]
        
        vStackViews.forEach { view in
            detailVerticalStack.addArrangedSubview(view)
        }
        
        parentViews.forEach { view in
            parentHorizontalStack.addArrangedSubview(view)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            parentHorizontalStack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            parentHorizontalStack.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            parentHorizontalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            parentHorizontalStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -80)
        ])
    }
}
