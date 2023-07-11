//
//  PokemonDetailViewController.swift
//  PokeDex
//
//  Created by Hada Melino on 07/07/23.
//

import Combine
import UIKit

class PokemonDetailTableViewController: UITableViewController {
    
    private let viewModel: DefaultPokemonDetailViewModel
    private var cancellabels: Set<AnyCancellable> = .init()

    init(viewModel: DefaultPokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        viewModel.viewDidLoad()
        bindViewModel()
    }
    
    func registerCell() {
        tableView.register(PokemonStatsCell.self, forCellReuseIdentifier: PokemonStatsCell.id)
        tableView.register(PokemonEvolutionCell.self, forCellReuseIdentifier: PokemonEvolutionCell.id)
    }
    
    func bindViewModel() {
        viewModel.$items
            .filter { $0.count == 2 }
            .sink { [weak self] items in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }.store(in: &cancellabels)
    }
    
    func configureView() {
        tableView.separatorStyle = .none
        registerCell()
    }

}

extension PokemonDetailTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch viewModel.items[indexPath.row] {
        case .stats(let pokemonStats):
            let cell = tableView.dequeueReusableCell(withIdentifier: PokemonStatsCell.id, for: indexPath) as! PokemonStatsCell
            cell.configureView(with: pokemonStats)
            return cell
        case .evolution(let pokemonEvolution):
            let cell = tableView.dequeueReusableCell(withIdentifier: PokemonEvolutionCell.id, for: indexPath) as! PokemonEvolutionCell
            cell.configureView(with: pokemonEvolution)
            return cell
        }
        
    }
}
