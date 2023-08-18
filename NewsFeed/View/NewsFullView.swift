//
//  NewsFullView.swift
//  NewsFeed
//
//  Created by Данік on 18/08/2023.
//

import Foundation
import UIKit
import SnapKit

@IBDesignable
class NewsFullView: UIView {
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        setupScrollView()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupScrollView() {
        addSubview(scrollView)
        scrollView.addSubview(contentContainerView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentContainerView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView) // this will make it scroll vertically only
        }
    }
    
    private let scrollView = UIScrollView()
    private let contentContainerView = UIView()
    
    private let dateAndSourceLabel = UILabel().apply {
        $0.font = UIFont(name: "Poppins-Medium", size: 12)
        $0.textColor = K.labelGray
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let titleLabel = UILabel().apply {
        $0.textAlignment = .left
        $0.font = UIFont(name: "Poppins-Bold", size: 16)
        $0.textColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.clipsToBounds = true
    }
    
    private let readInSourceLabel = UIButton().apply {
        let yourAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.red,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(
              string: "read in source",
              attributes: yourAttributes
            )
        $0.setAttributedTitle(attributeString, for: .normal)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let imageView = UIImageView().apply {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let descriptionLabel = UILabel().apply {
        $0.textAlignment = .left
        $0.font = UIFont(name: "Poppins-Medium", size: 16)
        $0.textColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfLines = 0
        $0.clipsToBounds = false
        $0.setContentCompressionResistancePriority(.required, for: .vertical)
    }
    
    func configure(dateAndSource: String, withTitle title: String, withUrl url: String, withImageUrl imageUrl: String, withDescription description: String) {
        self.backgroundColor = .clear
        dateAndSourceLabel.text = dateAndSource
        titleLabel.text = title
        imageView.sd_setImage(with: URL(string: imageUrl))
        descriptionLabel.text = description
        setupView()
    }
    
    private func setupView() {
        // add subviews here
        self.backgroundColor = K.backgroundGray
        
        contentContainerView.clipsToBounds = false

        contentContainerView.addSubview(dateAndSourceLabel)
        contentContainerView.addSubview(titleLabel)
        contentContainerView.addSubview(readInSourceLabel)
        contentContainerView.addSubview(imageView)
        contentContainerView.addSubview(descriptionLabel)
        
        // Adjust the bottom constraint to set the content size
        descriptionLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentContainerView).offset(-16) // This will determine the scroll view's content height
        }
        
        dateAndSourceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentContainerView.snp.top).offset(16)
            make.left.equalToSuperview().offset(12)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateAndSourceLabel.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
        
        readInSourceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.equalToSuperview().offset(16)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(readInSourceLabel.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(200)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
    }
}
