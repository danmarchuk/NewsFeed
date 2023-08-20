//
//  NewsCell.swift
//  NewsFeed
//
//  Created by Данік on 10/08/2023.
//

import UIKit
import SnapKit
import SDWebImage
import Kingfisher

final class NewsCell: UICollectionViewCell {
    static let identifier = "NewsCell"
    var bookmarkTapped: ((Int) -> Void)?

    private let dateAndSourceLabel = UILabel().apply {
        $0.font = UIFont(name: "Poppins-Medium", size: 12)
        $0.textColor = K.labelGray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }

    private let titleLabel = UILabel().apply {
        $0.textAlignment = .left
        $0.font = UIFont(name: "Poppins-Bold", size: 24)
        $0.textColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.clipsToBounds = true
    }
    
    let bookmarkButton = UIButton().apply {
        let image = UIImage(named: "savedImage")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = .white
    }

    let imageView = UIImageView().apply {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func configure(withArticle article: Article, dateAndSource: String) {
        dateAndSourceLabel.text = dateAndSource
        titleLabel.text = article.title
        let placeholderImage = UIImage(named: "16and9")
        imageView.kf.setImage(with: URL(string: article.pictureLink), placeholder: placeholderImage)
        bookmarkButton.tintColor = article.isSaved ? .red : .white
    }
    
    @objc func bookmarkButtonAction(_ sender: UIButton) {
        bookmarkTapped?(sender.tag)
    }
    
    private func setupView() {
        self.backgroundColor = .clear
        
        addSubview(dateAndSourceLabel)
        addSubview(bookmarkButton)
        addSubview(titleLabel)
        addSubview(imageView)
        
        bookmarkButton.addTarget(self, action: #selector(bookmarkButtonAction(_:)), for: .touchUpInside)
        
        dateAndSourceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        bookmarkButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(72)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bookmarkButton.snp.bottom).offset(8)
            make.left.equalTo(dateAndSourceLabel.snp.left)
            make.right.equalToSuperview().inset(16)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(300)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

