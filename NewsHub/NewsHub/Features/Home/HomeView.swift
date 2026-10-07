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
        addSubview(filterScrollView)
        filterScrollView.addSubview(filterStackView)
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
            
            filterScrollView.topAnchor.constraint(
                equalTo: searchBar.bottomAnchor,
                constant: 24),
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
            

        ])
    }
}
