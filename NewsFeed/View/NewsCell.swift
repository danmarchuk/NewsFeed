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
    }
    
    private let savedButton = UIButton().apply {
        $0.setImage(UIImage(named: "savedImage"), for: .normal)
    }

    private let imageView = UIImageView().apply {
        $0.contentMode = .scaleAspectFill
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
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
        
        horizontalStackView.addArrangedSubview(dateAndSourceLabel)
        horizontalStackView.addArrangedSubview(savedButton)
        
        verticalStackView.addArrangedSubview(horizontalStackView)
        verticalStackView.addArrangedSubview(titleLabel)
        verticalStackView.addArrangedSubview(imageView)
        
        mainStackView.addArrangedSubview(verticalStackView)
        
        addSubview(mainStackView)
        
        mainStackView.snp.makeConstraints { make in
            make.left.right.bottom.top.equalToSuperview()
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
        }
        
        
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // This constraint ensures the button does not get squashed in the stackView
        savedButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
    }
}

