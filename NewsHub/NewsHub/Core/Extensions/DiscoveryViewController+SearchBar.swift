//
//  DiscoveryViewController+SearchBar.swift
//  NewsHub
//
//  Created by breno.farias on 09/10/26.
//

import UIKit

extension DiscoveryViewController: UISearchBarDelegate {
    
    func searchBar(
        _ searchBar: UISearchBar,
        textDidChange searchText: String) {
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            
            searchTask?.cancel() // cancela a tarefa de pesquisa anterior, se houver
            
            guard !query.isEmpty else {
                searchTask = Task { [weak self] in
                    guard !Task.isCancelled, let self else { return } // checa se a tarefa atual (buscar as noticias) nao foi cancelada
                    
                    let news = await self.viewModel.loadDiscoveryContent() // carrega as notícias (porque o usuario apagou a pesquisa)
                    
                    guard !Task.isCancelled else { return } // checa se a tarefa de carregar as noticias nao foi cancelada
                    
                    self.contentView.display(news: news) // mostra as noticias carregadas na tela
                }
                
                return
            }
            
            guard query.count >= 3 else { return }
            
            searchTask = Task { [weak self] in
                do {
                    try await Task.sleep(for: .milliseconds(500))
                    guard !Task.isCancelled, let self else { return } // checa se a tarefa atual (buscar as noticias) nao foi cancelada
                    
                    let news = await self.viewModel.searchNews(query: query) // pequisa as notícias (porque o usuario digitou algo)
                    
                    guard !Task.isCancelled else { return } // checa se a tarefa de pesquisar as noticias nao foi cancelada
                    self.contentView.display(news: news) // mostra as noticias carregadas na tela
                    
                } catch {
                    // a tarefa foi cancelada porque o usuario continuou digitando
                }
            }
            
        }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchTask?.cancel() // cancela a tarefa de pesquisa, se tiver
        
        searchBar.showsCancelButton = false
        searchBar.text = nil
        searchBar.resignFirstResponder()
        
        searchTask = Task { [weak self] in
            guard !Task.isCancelled, let self else { return } // checa se a tarefa atual (clicar no botao de cancelar) nao foi cancelada

            let news = await self.viewModel.loadDiscoveryContent() // carrega as notícias (por que o usuario cancelou a pesquisa)
            
            guard !Task.isCancelled else { return } // checa se a tarefa de carregar as noticias nao foi cancelada
            
            self.contentView.display(news: news) // mostra as noticias carregadas na tela
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    
}
