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

        ])
    }
}
