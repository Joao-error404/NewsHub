//
//  HomeViewController.swift
//  NewsHub
//
//  Created by breno.farias on 07/10/26.
//

import UIKit

class HomeViewController: UIViewController {
    let contentView = HomeView()
    let viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
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
        
        setupView()
        
        Task {
            let news = await viewModel.loadNews()
            contentView.display(news: news)
        }
    }
    
    private func setupView() {
    }
}
