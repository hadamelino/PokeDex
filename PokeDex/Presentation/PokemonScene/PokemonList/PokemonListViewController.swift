//
//  ViewController.swift
//  PokeDex
//
//  Created by Hada Melino on 06/07/23.
//

import Combine
import UIKit

class PokemonListViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        view.register(PokemonCollectionViewCell.self, forCellWithReuseIdentifier: PokemonCollectionViewCell.id)
        view.backgroundColor = .white
        view.dataSource = self
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()

    
    private let viewModel: DefaultPokemonListViewModel
    
    private var cancellabels: Set<AnyCancellable> = .init()
    
    init(viewModel: DefaultPokemonListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildView()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    @objc func refresh() {
        viewModel.didTryRefreshForConnection()
    }
        
    private func configureLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func buildView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.addSubview(refreshControl)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func bindViewModel() {
        viewModel.$items
            .sink { [weak self] items in
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            }.store(in: &cancellabels)
        
        viewModel.$error
            .filter { !$0.isEmpty }
            .sink { [weak self] error in
                let message = "\(error) \n Currently, we only display the data stored on your local storage. Check your internet connection and refresh"
                self?.showAlert(title: "Error", message: message)
            }.store(in: &cancellabels)
        
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                if !isLoading {
                    DispatchQueue.main.async {
                        self?.refreshControl.endRefreshing()
                    }
                }
            }.store(in: &cancellabels)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Refresh", style: .default, handler: { action in
            self.viewModel.didTryRefreshForConnection()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension PokemonListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.id, for: indexPath) as! PokemonCollectionViewCell
        cell.configure(item: viewModel.items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.items.count - 1 {
            viewModel.didLoadNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath)
    }
    
}

