//
//  HomeView.swift
//  NewsHub
//
//  Created by breno.farias on 07/10/26.
//

import UIKit

class HomeView: UIView {
    
    private var searchBarHeightConstraint: NSLayoutConstraint!
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "NewsHub"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "ContrastColor")
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Pesquisar notícias"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.alpha = .zero
        searchBar.autocapitalizationType = .none
        searchBar.clipsToBounds = true
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.layer.cornerRadius = 20
        searchBar.searchTextField.clipsToBounds = true
        return searchBar
    }()
    
    private lazy var toggleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = UIColor(named: "ContrastColor")
        button.addTarget(self, action: #selector(toggleSearchBar), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [title, toggleButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var lastNewsLabel: UILabel = {
        let label = UILabel()
        label.text = "Últimas Notícias"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor(named: "ContrastColor")
        return label
    }()
    
    private lazy var seeAll: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ver todas", for: .normal)
        button.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var lastNewsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [lastNewsLabel, seeAll])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var newsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var newsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var featuredLabel: UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(
            string: "EM DESTAQUE",
            attributes: [
                .font: UIFont.systemFont(ofSize: 10, weight: .bold),
                .foregroundColor: UIColor(named: "AccentColor") ?? UIColor.systemRed,
                .kern: 2
            ]
        )
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var featuredDot: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "AccentColor") ?? UIColor.systemRed
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 10),
            view.heightAnchor.constraint(equalToConstant: 10)
        ])
        return view
    }()

    private lazy var featuredHeader: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [featuredLabel, featuredDot])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var featuredSection: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [featuredHeader])
        stackView.axis = .vertical
        stackView.spacing = 14
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            featuredSection,
            lastNewsStackView,
            newsStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 22
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    func display(news: [News]) {
        featuredSection.arrangedSubviews
            .filter { $0 !== featuredHeader }
            .forEach { view in
                featuredSection.removeArrangedSubview(view)
                view.removeFromSuperview()
            }

        newsStackView.arrangedSubviews.forEach { view in
            newsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        if let featuredNews = news.first {
            featuredSection.addArrangedSubview(
                makeFeaturedNewsContainer(news: featuredNews)
            )
        }

        news.dropFirst().forEach { article in
            newsStackView.addArrangedSubview(
                NewsCard(news: article)
            )
        }
    }

    private func makeFeaturedNewsContainer(news: News) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemGray5
        container.layer.cornerRadius = 28
        container.clipsToBounds = true
        container.translatesAutoresizingMaskIntoConstraints = false

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "photo")
        imageView.tintColor = .systemGray3
        imageView.translatesAutoresizingMaskIntoConstraints = false

        let gradientView = NewsGradientOverlayView()
        gradientView.translatesAutoresizingMaskIntoConstraints = false

        let titleLabel = UILabel()
        titleLabel.text = news.title ?? "Título indisponível"
        titleLabel.font = UIFont(name: "Georgia", size: 28)
            ?? .systemFont(ofSize: 28, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 3
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let metadataLabel = UILabel()
        let author = news.author.flatMap { $0.isEmpty ? nil : $0 }
            ?? news.source.name.flatMap { $0.isEmpty ? nil : $0 }
        let date = formattedPublicationDate(news.publishedAt)
        metadataLabel.text = author.map { "Por \($0) · \(date)" } ?? date
        metadataLabel.font = .systemFont(ofSize: 12, weight: .medium)
        metadataLabel.textColor = UIColor.white.withAlphaComponent(0.70)
        metadataLabel.numberOfLines = 1
        metadataLabel.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(imageView)
        container.addSubview(gradientView)
        container.addSubview(titleLabel)
        container.addSubview(metadataLabel)

        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 360),

            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            gradientView.topAnchor.constraint(equalTo: container.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: container.bottomAnchor),

            metadataLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 22),
            metadataLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -22),
            metadataLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -22),

            titleLabel.leadingAnchor.constraint(equalTo: metadataLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: metadataLabel.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: metadataLabel.topAnchor, constant: -12),
        ])

        loadImage(from: news.urlToImage, into: imageView)
        return container
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
        guard let urlString, let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
    
    @objc private func toggleSearchBar() {
        self.layoutIfNeeded()

        let isClosed = searchBarHeightConstraint.constant == 0
        self.searchBarHeightConstraint.constant = isClosed ? 44 : 0
        
        UIView.animate(
            withDuration: 0.3
        ) {
            self.searchBar.alpha = isClosed ? 1 : 0
            self.layoutIfNeeded()
        }
        
        self.toggleButton.setImage(UIImage(systemName: isClosed ? "xmark" : "magnifyingglass"), for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        backgroundColor = UIColor(named: "BackgroundColor")
        
        setHierarchy()
        setConstraints()
    }
    
    private func setHierarchy() {
        addSubview(titleStackView)
        addSubview(searchBar)
        addSubview(newsScrollView)
        newsScrollView.addSubview(contentStackView)
    }
    
    private func setConstraints() {
        searchBarHeightConstraint = searchBar.heightAnchor.constraint(
            equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            searchBarHeightConstraint,
            
            titleStackView.topAnchor.constraint(
                equalTo: topAnchor,
                constant: 72),
            titleStackView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 16),
            titleStackView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -16),
            
            
            searchBar.topAnchor.constraint(
                equalTo: titleStackView.bottomAnchor,
                constant: 8),
            searchBar.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 8),
            searchBar.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -8),
            
            newsScrollView.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor,
                constant: 20),
            newsScrollView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 16),
            newsScrollView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -16),
            newsScrollView.bottomAnchor.constraint(
                equalTo: bottomAnchor),

            contentStackView.leadingAnchor.constraint(
                equalTo: newsScrollView.contentLayoutGuide.leadingAnchor),
            contentStackView.trailingAnchor.constraint(
                equalTo: newsScrollView.contentLayoutGuide.trailingAnchor),
            contentStackView.topAnchor.constraint(
                equalTo: newsScrollView.contentLayoutGuide.topAnchor),
            contentStackView.bottomAnchor.constraint(
                equalTo: newsScrollView.contentLayoutGuide.bottomAnchor),
            contentStackView.widthAnchor.constraint(
                equalTo: newsScrollView.frameLayoutGuide.widthAnchor),
        ])
    }
}

private final class NewsGradientOverlayView: UIView {
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.2).cgColor,
            UIColor.black.withAlphaComponent(0.9).cgColor
        ]
        gradientLayer.locations = [0, 0.48, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.addSublayer(gradientLayer)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
