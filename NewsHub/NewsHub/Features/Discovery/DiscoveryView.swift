//
//  DiscoveryView.swift
//  NewsHub
//
//  Created by breno.farias on 08/10/26.
//

import UIKit

class DiscoveryView: UIView{
    private lazy var title: UILabel = {
        let label = UILabel()
        label.text = "Explorar"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            newsStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 22
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private func makeNewsContainer(news: News) -> UIView {
        let container = UIView()
        container.backgroundColor = .white
        container.layer.cornerRadius = 18
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemGray5.cgColor
        container.translatesAutoresizingMaskIntoConstraints = false

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

        let textStackView = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        textStackView.axis = .vertical
        textStackView.alignment = .leading
        textStackView.spacing = 8
        textStackView.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(imageView)
        container.addSubview(textStackView)

        NSLayoutConstraint.activate([
                container.heightAnchor.constraint(equalToConstant: 140),

                imageView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
                imageView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                imageView.widthAnchor.constraint(equalToConstant: 112),
                imageView.heightAnchor.constraint(equalToConstant: 112),

                textStackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
                textStackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
                textStackView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
        ])

        loadImage(from: news.urlToImage, into: imageView)
        return container
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
    
    func display(news: [News]) {
        newsStackView.arrangedSubviews.forEach { view in
            newsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        news.forEach { article in
            newsStackView.addArrangedSubview(
                makeNewsContainer(news: article)
            )
        }
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
        addSubview(title)
        
        addSubview(newsScrollView)
        newsScrollView.addSubview(contentStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            newsScrollView.topAnchor.constraint(
                equalTo: title.bottomAnchor,
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
