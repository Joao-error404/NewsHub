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
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
            newsStackView
        ])
        stackView.axis = .vertical
        stackView.spacing = 22
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(title)
       
        addSubview(searchBar)
        
        addSubview(filterScrollView)
        filterScrollView.addSubview(filterStackView)
        
        addSubview(newsScrollView)
        newsScrollView.addSubview(contentStackView)
       
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            searchBar.topAnchor.constraint(
                equalTo: title.bottomAnchor,
                constant: 1
            ),
            searchBar.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 8
            ),
            searchBar.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -8
            ),
            
            filterScrollView.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor,
                constant: 16),
            filterScrollView.leadingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.leadingAnchor,
                constant: 16),
            filterScrollView.trailingAnchor.constraint(
                equalTo: safeAreaLayoutGuide.trailingAnchor,
                constant: -16),
            filterScrollView.heightAnchor.constraint(equalToConstant: 40),

            filterStackView.leadingAnchor.constraint(
                equalTo: filterScrollView.contentLayoutGuide.leadingAnchor),
            filterStackView.trailingAnchor.constraint(
                equalTo: filterScrollView.contentLayoutGuide.trailingAnchor),
            filterStackView.topAnchor.constraint(
                equalTo: filterScrollView.contentLayoutGuide.topAnchor),
            filterStackView.bottomAnchor.constraint(
                equalTo: filterScrollView.contentLayoutGuide.bottomAnchor),
            filterStackView.heightAnchor.constraint(
                equalTo: filterScrollView.frameLayoutGuide.heightAnchor),
            
            newsScrollView.topAnchor.constraint(
                equalTo: filterScrollView.bottomAnchor,
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
