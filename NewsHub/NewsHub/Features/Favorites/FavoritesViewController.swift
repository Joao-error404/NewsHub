//
//  FavoritesViewController.swift
//  NewsHub
//
//  Created by breno.farias on 09/10/26.
//

import UIKit

class FavoritesViewController: UIViewController {
    let contentView = FavoritesView()
    let viewModel = FavoritesViewModel()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = "Favoritos"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        
        Task {
            await viewModel.loadFavorites()
            contentView.display(news: viewModel.favoriteNews)
        }
    }


}
