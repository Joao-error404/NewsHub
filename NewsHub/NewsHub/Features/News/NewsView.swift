//
//  NewsView.swift
//  NewsHub
//
//  Created by breno.farias on 13/10/26.
//

import UIKit

final class NewsView: UIView {
    var onReadArticle: (() -> Void)?

    private let paperColor = UIColor(red: 0.975, green: 0.970, blue: 0.948, alpha: 1)
    private let inkColor = UIColor(named: "ContrastColor") ?? .label
    private let accentColor = UIColor(named: "AccentColor") ?? .systemOrange

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var scrollContent: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var heroView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.03, green: 0.24, blue: 0.22, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.tintColor = .white.withAlphaComponent(0.3)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var gradient: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.black.withAlphaComponent(0.15).cgColor,
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.8).cgColor
        ]
        gradient.locations = [0, 0.45, 1]
        return gradient
    }()

    private lazy var articlePanel: UIView = {
        let view = UIView()
        view.backgroundColor = paperColor
        view.layer.cornerRadius = 30
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var sourceLabel: UILabel = {
        let label = UILabel()
        styleLabel(label, size: 10, weight: .bold, color: .white)
        return label
    }()

    private lazy var sourceBadge: UIView = {
        let view = UIView()
        view.backgroundColor = accentColor
        view.layer.cornerRadius = 14
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        styleLabel(label, size: 9, weight: .semibold, color: .secondaryLabel)
        label.text = "NOTÍCIA"
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private lazy var sourceRow: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sourceBadge, categoryLabel, UIView()])
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = serifFont(size: 38, textStyle: .largeTitle, weight: .bold)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = inkColor
        label.numberOfLines = 0
        label.accessibilityTraits = .header
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        styleLabel(label, size: 16, weight: .regular, color: .secondaryLabel)
        return label
    }()

    private lazy var initialsLabel: UILabel = {
        let label = UILabel()
        styleLabel(label, size: 12, weight: .bold, color: inkColor)
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 0.86, green: 0.91, blue: 0.84, alpha: 1)
        label.layer.cornerRadius = 22
        label.clipsToBounds = true
        label.isAccessibilityElement = false
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        styleLabel(label, size: 12, weight: .bold, color: inkColor)
        return label
    }()

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        styleLabel(label, size: 10, weight: .regular, color: .secondaryLabel)
        return label
    }()

    private lazy var authorStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authorLabel, dateLabel])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var readingTimeLabel: UILabel = {
        let label = UILabel()
        styleLabel(label, size: 10, weight: .regular, color: .secondaryLabel)
        return label
    }()

    private lazy var clockImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "clock"))
        imageView.tintColor = .secondaryLabel
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var readingStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [clockImageView, readingTimeLabel])
        stackView.spacing = 6
        stackView.alignment = .center
        stackView.setContentCompressionResistancePriority(.required, for: .horizontal)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var authorRow: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [initialsLabel, authorStack, readingStack])
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var readArticleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Ler publicação original ↗", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.tintColor = accentColor
        button.contentHorizontalAlignment = .leading
        button.addTarget(self, action: #selector(readArticleTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var articleStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            sourceRow,
            titleLabel,
            descriptionLabel,
            separator(),
            authorRow,
            separator(),
            bodyLabel,
            readArticleButton
        ])
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.setCustomSpacing(16, after: sourceRow)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private var imageTask: URLSessionDataTask?
    private var imageRequestID = UUID()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        imageTask?.cancel()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = heroView.bounds
    }

    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
        scrollView.contentInset.bottom = safeAreaInsets.bottom
    }

    func configure(with news: News) {
        let source = nonempty(news.source.name) ?? "Fonte desconhecida"
        let author = nonempty(news.author) ?? source
        titleLabel.text = nonempty(news.title) ?? "Título indisponível"
        descriptionLabel.text = nonempty(news.description)
        descriptionLabel.isHidden = descriptionLabel.text == nil
        sourceLabel.text = source.uppercased()
        authorLabel.text = author
        initialsLabel.text = author.split(whereSeparator: { $0.isWhitespace })
            .prefix(2).compactMap { $0.first }.map { String($0) }.joined().uppercased()
        dateLabel.text = formattedDate(news.publishedAt)

        let content = nonempty(news.content)
        configureBody(content ?? "Conteúdo indisponível. Consulte a publicação original.")
        let wordCount = content?.split(whereSeparator: { $0.isWhitespace }).count ?? 0
        readingTimeLabel.text = wordCount > 0 ? "~ \(max(1, Int(ceil(Double(wordCount) / 200)))) min" : nil
        readingTimeLabel.accessibilityLabel = wordCount > 0
            ? "Tempo estimado de leitura do conteúdo disponível: \(readingTimeLabel.text ?? "")" : nil
        readingTimeLabel.isHidden = wordCount == 0
        let hasURL = articleURL(news.url) != nil
        readArticleButton.isHidden = !hasURL
        loadImage(news.urlToImage)
    }

    private func setupView() {
        backgroundColor = paperColor

        setHierarchy()
        setConstraints()
    }

    private func setHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(scrollContent)
        scrollContent.addSubview(heroView)
        scrollContent.addSubview(articlePanel)
        heroView.addSubview(imageView)
        heroView.layer.addSublayer(gradient)
        articlePanel.addSubview(articleStack)
        sourceBadge.addSubview(sourceLabel)
    }

    private func setConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollContent.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            scrollContent.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollContent.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            scrollContent.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            scrollContent.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            heroView.topAnchor.constraint(equalTo: scrollContent.topAnchor),
            heroView.leadingAnchor.constraint(equalTo: scrollContent.leadingAnchor),
            heroView.trailingAnchor.constraint(equalTo: scrollContent.trailingAnchor),
            heroView.heightAnchor.constraint(equalToConstant: 370),
            imageView.topAnchor.constraint(equalTo: heroView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: heroView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: heroView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: heroView.trailingAnchor),
            
            articlePanel.topAnchor.constraint(equalTo: heroView.bottomAnchor, constant: -30),
            articlePanel.leadingAnchor.constraint(equalTo: scrollContent.leadingAnchor),
            articlePanel.trailingAnchor.constraint(equalTo: scrollContent.trailingAnchor),
            articlePanel.bottomAnchor.constraint(equalTo: scrollContent.bottomAnchor),
            articleStack.topAnchor.constraint(equalTo: articlePanel.topAnchor, constant: 28),
            articleStack.leadingAnchor.constraint(equalTo: articlePanel.leadingAnchor, constant: 25),
            articleStack.trailingAnchor.constraint(equalTo: articlePanel.trailingAnchor, constant: -25),
            articleStack.bottomAnchor.constraint(equalTo: articlePanel.bottomAnchor, constant: -48),
            sourceLabel.topAnchor.constraint(equalTo: sourceBadge.topAnchor, constant: 8),
            sourceLabel.bottomAnchor.constraint(equalTo: sourceBadge.bottomAnchor, constant: -8),
            sourceLabel.leadingAnchor.constraint(equalTo: sourceBadge.leadingAnchor, constant: 12),
            sourceLabel.trailingAnchor.constraint(equalTo: sourceBadge.trailingAnchor, constant: -12),
            initialsLabel.widthAnchor.constraint(equalToConstant: 44),
            initialsLabel.heightAnchor.constraint(equalToConstant: 44),
            clockImageView.widthAnchor.constraint(equalToConstant: 12),
            clockImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    private func styleLabel(_ label: UILabel, size: CGFloat, weight: UIFont.Weight, color: UIColor) {
        label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: size, weight: weight))
        label.adjustsFontForContentSizeCategory = true
        label.textColor = color
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
    }

    private func separator() -> UIView {
        let view = UIView()
        view.backgroundColor = inkColor.withAlphaComponent(0.12)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1 / max(traitCollection.displayScale, 1)).isActive = true
        return view
    }

    private func serifFont(size: CGFloat, textStyle: UIFont.TextStyle, weight: UIFont.Weight = .regular) -> UIFont {
        let base = UIFont.systemFont(ofSize: size, weight: weight)
        let font = base.fontDescriptor.withDesign(.serif).map { UIFont(descriptor: $0, size: size) } ?? base
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font)
    }

    private func configureBody(_ text: String) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 7
        let attributed = NSMutableAttributedString(string: text, attributes: [
            .font: serifFont(size: 22, textStyle: .body),
            .foregroundColor: inkColor,
            .paragraphStyle: paragraph
        ])
        if let first = text.first {
            attributed.addAttributes([
                .font: serifFont(size: 54, textStyle: .largeTitle, weight: .bold),
                .foregroundColor: accentColor
            ], range: NSRange(location: 0, length: String(first).utf16.count))
        }
        bodyLabel.attributedText = attributed
    }

    private func nonempty(_ value: String?) -> String? {
        guard let value = value?.trimmingCharacters(in: .whitespacesAndNewlines), !value.isEmpty else { return nil }
        return value
    }

    private func articleURL(_ value: String?) -> URL? {
        guard let value = nonempty(value), let url = URL(string: value),
              ["https", "http"].contains(url.scheme?.lowercased() ?? ""), url.host != nil else { return nil }
        return url
    }

    private func formattedDate(_ value: String?) -> String {
        guard let value = nonempty(value) else { return "Data indisponível" }
        let parser = ISO8601DateFormatter()
        parser.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let fractionalDate = parser.date(from: value)
        parser.formatOptions = [.withInternetDateTime]
        guard let date = fractionalDate ?? parser.date(from: value) else { return "Data indisponível" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "dd 'de' MMMM 'às' HH:mm"
        return formatter.string(from: date)
    }

    private func loadImage(_ value: String?) {
        imageTask?.cancel()
        imageRequestID = UUID()
        
        let requestID = imageRequestID
        
        imageView.image = UIImage(systemName: "photo")
        
        guard let value = nonempty(value), var components = URLComponents(string: value) else { return }
        
        if components.scheme?.lowercased() == "http" { components.scheme = "https" }
        
        guard let url = components.url, url.scheme?.lowercased() == "https", url.host != nil else { return }
        
        imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, _ in
            guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode),
                  let data, let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async { [weak self] in
                guard let self, self.imageRequestID == requestID else { return }
                self.imageView.image = image
            }
        }
        
        imageTask?.resume()
    }

    @objc private func readArticleTapped() { onReadArticle?() }
}

