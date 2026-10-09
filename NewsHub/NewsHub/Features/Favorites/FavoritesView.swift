//
//  FavoritesView.swift
//  NewsHub
//
//  Created by breno.farias on 09/10/26.
//

import UIKit

class FavoritesView: UIView {
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
    
    func display(news: [News]) {
        newsStackView.arrangedSubviews.forEach { view in
            newsStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }

        news.forEach { article in
            newsStackView.addArrangedSubview(
                NewsCard(news: article)
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
        addSubview(newsScrollView)
        newsScrollView.addSubview(contentStackView)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            newsScrollView.topAnchor.constraint(equalTo: topAnchor),
            newsScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newsScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newsScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentStackView.leadingAnchor.constraint(
                equalTo: newsScrollView.contentLayoutGuide.leadingAnchor,
                constant: 16
            ),
            contentStackView.trailingAnchor.constraint(
                equalTo: newsScrollView.contentLayoutGuide.trailingAnchor,
                constant: -16
            ),
            contentStackView.topAnchor.constraint(equalTo: newsScrollView.contentLayoutGuide.topAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: newsScrollView.contentLayoutGuide.bottomAnchor),
            contentStackView.widthAnchor.constraint(
                equalTo: newsScrollView.frameLayoutGuide.widthAnchor,
                constant: -32
            ),
        ])
    }
}
