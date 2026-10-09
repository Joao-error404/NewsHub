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
    
    var searchTask: Task<Void, Never>?
    
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
        
        contentView.onFilterSelected = { [weak self] filter in
            guard let self else { return }
            
            switch filter {
            case "noticia":
                self.loadDiscoveryContent()
            case "esportes", "entretenimento", "tecnologia", "saúde", "ciência":
                self.searchTask?.cancel()
                
                self.searchTask = Task { [weak self] in
                    guard let self, !Task.isCancelled else { return }
                    
                    let news = await self.viewModel.searchNews(query: filter)
                    
                    guard !Task.isCancelled else { return }
                    self.contentView.display(news: news)
                }
                
            default:
                break
            }
        }
        
        loadDiscoveryContent()
        contentView.setupSearchBar(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Explorar"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func loadDiscoveryContent() {
        searchTask?.cancel() // cancela uma tarefa de pesquisa, se tiver
        
        searchTask = Task { [weak self] in
            guard !Task.isCancelled, let self else { return } // checa se a tarefa atual (buscar as noticias) nao foi cancelada
            
            let reponse = await self.viewModel.loadDiscoveryContent() // carrega as notícias
            
            guard !Task.isCancelled else { return } // checa se a tarefa atual (buscar as noticias) nao foi cancelada
            self.contentView.display(news: reponse) // mostra as noticias carregadas na tela
        }
    }
}
