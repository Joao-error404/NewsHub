//
//  NewsViewController.swift
//  NewsHub
//
//  Created by breno.farias on 13/10/26.
//

import Combine
import SafariServices
import UIKit

class NewsViewController: UIViewController {
    private let news: News
    let contentView = NewsView()
    private let favoritesStore = FavoriteNewsStore.shared
    private var favoritesSubscription: AnyCancellable?
    private var isUpdatingFavorite = false

    private lazy var shareBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNews))
        item.accessibilityLabel = "Compartilhar notícia"
        return item
    }()

    private lazy var favoriteBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(
            image: UIImage(systemName: "bookmark"),
            style: .plain,
            target: self,
            action: #selector(toggleFavorite)
        )
        item.accessibilityLabel = "Adicionar aos favoritos"
        return item
    }()
    
    init(news: News) {
        self.news = news
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = contentView
        contentView.configure(with: news)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        
        shareBarButtonItem.isEnabled = articleURL != nil
        
        contentView.onReadArticle = { [weak self] in
            guard let self, let url = self.articleURL else { return }
            self.present(SFSafariViewController(url: url), animated: true)
        }
        favoritesSubscription = favoritesStore.$favorites.sink { [weak self] _ in
            self?.updateFavoriteState()
        }
    }

    private func configureNavigationBar() {
        edgesForExtendedLayout = [.top, .bottom]
        extendedLayoutIncludesOpaqueBars = true
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItems = [favoriteBarButtonItem, shareBarButtonItem]

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.compactScrollEdgeAppearance = appearance
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private var articleURL: URL? {
        guard let value = news.url?.trimmingCharacters(in: .whitespacesAndNewlines),
              let url = URL(string: value),
              ["http", "https"].contains(url.scheme?.lowercased() ?? ""), url.host != nil else { return nil }
        return url
    }

    @objc private func shareNews() {
        guard let url = articleURL else { return }
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        activityController.popoverPresentationController?.barButtonItem = shareBarButtonItem
        present(activityController, animated: true)
    }

    private func updateFavoriteState() {
        let isFavorite = favoritesStore.isFavorite(news)
        let canFavorite = favoritesStore.canFavorite(news)
        favoriteBarButtonItem.image = UIImage(systemName: isFavorite ? "bookmark.fill" : "bookmark")
        favoriteBarButtonItem.isEnabled = canFavorite && !isUpdatingFavorite
        favoriteBarButtonItem.accessibilityLabel = !canFavorite
            ? "Favoritos indisponíveis"
            : (isFavorite ? "Remover dos favoritos" : "Adicionar aos favoritos")
    }

    @objc private func toggleFavorite() {
        guard favoritesStore.canFavorite(news), !isUpdatingFavorite else { return }
        isUpdatingFavorite = true
        updateFavoriteState()
        Task { [weak self] in
            guard let self else { return }
            defer {
                self.isUpdatingFavorite = false
                self.updateFavoriteState()
            }
            do {
                try await self.favoritesStore.toggle(self.news)
            } catch {
                let alert = UIAlertController(
                    title: "Não foi possível atualizar os favoritos",
                    message: "Tente novamente.",
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            }
        }
    }
}
