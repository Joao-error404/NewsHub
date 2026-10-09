//
//  DiscoveryView.swift
//  NewsHub
//
//  Created by breno.farias on 08/10/26.
//

import UIKit

class DiscoveryView: UIView{
    private lazy var newsScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.keyboardDismissMode = .onDrag
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
            searchBar,
            filterScrollView,
            newsStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.setCustomSpacing(16, after: searchBar)
        return stackView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .minimal
        searchBar.autocapitalizationType = .none
        searchBar.clipsToBounds = true
        searchBar.backgroundColor = .clear
        searchBar.searchTextField.backgroundColor = UIColor(named: "ContrastColor")
        searchBar.searchTextField.textColor = UIColor.white.withAlphaComponent(0.65)
        searchBar.searchTextField.leftView?.tintColor = UIColor.white.withAlphaComponent(0.65)
        searchBar.searchTextField.borderStyle = .none
        searchBar.searchTextField.layer.cornerRadius = 20
        searchBar.searchTextField.clipsToBounds = true
        searchBar.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Pesquisar notícias",
            attributes: [
                .foregroundColor: UIColor.white.withAlphaComponent(0.65)
            ]
        )
        return searchBar
    }()
    
    private lazy var filterButtons: [UIButton] = [
        makeFilterButton(title: "Para você", isSelected: true),
        makeFilterButton(title: "Agora"),
        makeFilterButton(title: "Brasil"),
        makeFilterButton(title: "Mundo"),
        makeFilterButton(title: "Tecnologia")
    ]
    
    private lazy var filterStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: filterButtons)
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var filterScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private func makeFilterButton(title: String, isSelected: Bool = false) -> UIButton {
        let button = UIButton(type: .system)
        var configuration = UIButton.Configuration.filled()
        configuration.title = title
        configuration.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.boldSystemFont(ofSize: 12)
            return outgoing
        }
        configuration.baseForegroundColor = isSelected ? .white : .darkGray
        configuration.baseBackgroundColor = isSelected ? .black : UIColor.systemGray6
        configuration.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 16,
            bottom: 0,
            trailing: 16
        )
        configuration.cornerStyle = .capsule
        button.configuration = configuration
        button.titleLabel?.numberOfLines = 1
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 34).isActive = true
        return button
    }
    
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
    
    func setupSearchBar(delegate: UISearchBarDelegate) {
        searchBar.delegate = delegate
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
        filterScrollView.addSubview(filterStackView)
       
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            newsScrollView.topAnchor.constraint(
                equalTo: topAnchor
            ),
            newsScrollView.leadingAnchor.constraint(
                equalTo: leadingAnchor
            ),
            newsScrollView.trailingAnchor.constraint(
                equalTo: trailingAnchor
            ),
            newsScrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentStackView.leadingAnchor.constraint(
                equalTo: newsScrollView.contentLayoutGuide.leadingAnchor,
                constant: 16
            ),
            contentStackView.trailingAnchor.constraint(
                equalTo: newsScrollView.contentLayoutGuide.trailingAnchor,
                constant: -16
            ),
            contentStackView.topAnchor.constraint(
                equalTo: newsScrollView.contentLayoutGuide.topAnchor
            ),
            contentStackView.bottomAnchor.constraint(
                equalTo: newsScrollView.contentLayoutGuide.bottomAnchor,
                constant: -32
            ),
            contentStackView.widthAnchor.constraint(
                equalTo: newsScrollView.frameLayoutGuide.widthAnchor,
                constant: -32
            ),

            filterScrollView.heightAnchor.constraint(equalToConstant: 40),

            filterStackView.leadingAnchor.constraint(
                equalTo: filterScrollView.contentLayoutGuide.leadingAnchor,
                constant: 8
            ),
            filterStackView.trailingAnchor.constraint(
                equalTo: filterScrollView.contentLayoutGuide.trailingAnchor,
                constant: -8
            ),
            filterStackView.topAnchor.constraint(
                equalTo: filterScrollView.contentLayoutGuide.topAnchor
            ),
            filterStackView.bottomAnchor.constraint(
                equalTo: filterScrollView.contentLayoutGuide.bottomAnchor
            ),
            filterStackView.heightAnchor.constraint(
                equalTo: filterScrollView.frameLayoutGuide.heightAnchor
            ),
        ])
    }
}
