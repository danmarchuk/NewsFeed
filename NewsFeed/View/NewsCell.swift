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
    
    private let savedButton = UIButton().apply {
        $0.setImage(UIImage(named: "savedImage"), for: .normal)
    }

    private let imageView = UIImageView().apply {
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
    
    func configure(withTitle title: String, dateAndSource: String, withImage image: String) {
        dateAndSourceLabel.text = dateAndSource
        titleLabel.text = title
        let placeholderImage = UIImage(named: "16and9")
        imageView.kf.setImage(with: URL(string: image), placeholder: placeholderImage)
        setupView()
    }
    
    
    
    private func setupView() {
        self.backgroundColor = .clear
        
        addSubview(dateAndSourceLabel)
        addSubview(titleLabel)
        addSubview(savedButton)
        addSubview(imageView)
        
        dateAndSourceLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        savedButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(72)
            make.top.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(savedButton.snp.bottom).offset(4)
            make.left.equalTo(dateAndSourceLabel.snp.left)
            make.right.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }


    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("imageView frame after layout: \(imageView.frame)")
    }
}

