//
//  File.swift
//  NewsFeed
//
//  Created by Данік on 10/08/2023.
//

import Foundation
import UIKit
import SnapKit

@IBDesignable
final class MainView: UIView {
    
    init() {
        super.init(frame: UIScreen.main.bounds)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let navbarLabel = UILabel().apply {
        $0.text = "Timeline"
        $0.font = UIFont(name: "Poppins-Medium", size: 16)
        $0.textColor = .white
    }
    
    func setupView() {
        
    }
}
