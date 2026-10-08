//
//  DiscoveryViewController.swift
//  NewsHub
//
//  Created by breno.farias on 08/10/26.
//

import UIKit

class DiscoveryViewController: UIViewController{
    let contentView = DiscoveryView()
    let viewModel = DiscoveryViewModel()
    
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
        
        loadDiscoveryContent()
    }
    
    private func loadDiscoveryContent() {
        Task {
            let reponse = await viewModel.loadDiscoveryContent()
            contentView.display(news: reponse)
        }
    }
}
