//
//  NewsCard.swift
//  NewsHub
//
//  Created by breno.farias on 08/10/26.
//

import Combine
import UIKit

final class NewsCard: UIView {
    private let news: News
    private let favoritesStore: FavoriteNewsStore
    private var favoritesSubscription: AnyCancellable?

    let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 20, weight: .medium)
        button.setImage(UIImage(systemName: "bookmark", withConfiguration: configuration), for: .normal)
        button.setImage(UIImage(systemName: "bookmark.fill", withConfiguration: configuration), for: .selected)
        button.tintColor = UIColor(named: "AccentColor") ?? .systemRed
        button.accessibilityLabel = "Adicionar aos favoritos"
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    init(news: News, favoritesStore: FavoriteNewsStore? = nil) {
        let favoritesStore = favoritesStore ?? .shared
        
        self.news = news
        self.favoritesStore = favoritesStore
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 18
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray5.cgColor
        translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray6
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 14
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .systemGray3

        let titleLabel = UILabel()
        titleLabel.text = news.title ?? "Título indisponível"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = UIColor(named: "ContrastColor")
        titleLabel.numberOfLines = 3
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let dateLabel = UILabel()
        dateLabel.text = formattedPublicationDate(news.publishedAt)
        dateLabel.font = .systemFont(ofSize: 11, weight: .regular)
        dateLabel.textColor = UIColor(named: "GraySecondaryColor")
        dateLabel.numberOfLines = 1
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        let footerStackView = UIStackView(arrangedSubviews: [dateLabel, favoriteButton])
        footerStackView.axis = .horizontal
        footerStackView.alignment = .center
        footerStackView.spacing = 8
        footerStackView.translatesAutoresizingMaskIntoConstraints = false

        let textStackView = UIStackView(arrangedSubviews: [titleLabel, footerStackView])
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.spacing = 8
        textStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(imageView)
        addSubview(textStackView)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 140),

            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 112),
            imageView.heightAnchor.constraint(equalToConstant: 112),

            textStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            textStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            textStackView.centerYAnchor.constraint(equalTo: centerYAnchor),

            footerStackView.widthAnchor.constraint(equalTo: textStackView.widthAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 22),
            favoriteButton.heightAnchor.constraint(equalToConstant: 22),
        ])

        favoriteButton.isEnabled = favoritesStore.canFavorite(news)
        favoriteButton.addTarget(self, action: #selector(toggleFavorite), for: .touchUpInside)
        favoritesSubscription = favoritesStore.$favorites.sink { [weak self] favorites in
            guard let self else { return }
            self.updateFavoriteButton(
                isFavorite: self.favoritesStore.canFavorite(news)
                    && favorites.contains(where: { $0.url == news.url })
            )
        }

        loadImage(from: news.urlToImage, into: imageView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func toggleFavorite() {
        guard favoritesStore.canFavorite(news), favoriteButton.isEnabled else { return }
        favoriteButton.isEnabled = false

        Task { [weak self] in
            guard let self else { return }
            
            defer {
                self.favoriteButton.isEnabled = self.favoritesStore.canFavorite(self.news)
            }

            do {
                try await self.favoritesStore.toggle(self.news)
            } catch {
                UIAccessibility.post(
                    notification: .announcement,
                    argument: "Não foi possível atualizar os favoritos. Tente novamente."
                )
            }
        }
    }

    private func updateFavoriteButton(isFavorite: Bool) {
        favoriteButton.isSelected = isFavorite
        if !favoritesStore.canFavorite(news) {
            favoriteButton.accessibilityLabel = "Favoritos indisponíveis para notícia sem URL"
        } else {
            favoriteButton.accessibilityLabel = isFavorite
                ? "Remover dos favoritos"
                : "Adicionar aos favoritos"
        }
    }

    private func formattedPublicationDate(_ value: String?) -> String {
        guard let value else { return "Data indisponível" }

        let isoFormatter = ISO8601DateFormatter()
        let date = isoFormatter.date(from: value)
            ?? {
                isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                return isoFormatter.date(from: value)
            }()

        guard let date else { return value }

        let relativeFormatter = RelativeDateTimeFormatter()
        relativeFormatter.locale = Locale(identifier: "pt_BR")
        relativeFormatter.unitsStyle = .abbreviated
        return relativeFormatter.localizedString(for: date, relativeTo: Date())
    }

    private func loadImage(from urlString: String?, into imageView: UIImageView) {
        guard let urlString, var components = URLComponents(string: urlString) else { return }

        if components.scheme?.lowercased() == "http" {
            components.scheme = "https"
        }

        guard let url = components.url else { return }

        URLSession.shared.dataTask(with: url) { [weak imageView] data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                imageView?.image = image
            }
        }.resume()
    }
}
