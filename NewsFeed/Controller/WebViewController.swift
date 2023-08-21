//
//  WebViewController.swift
//  NewsFeed
//
//  Created by Данік on 21/08/2023.
//

import Foundation
import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController {
    private let webView = WKWebView()
    private let url: URL
    private var xButton: UIBarButtonItem!
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupNavigationBar()
    }
    
    private func setupView() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func setupNavigationBar() {
        xButton = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(xButtonkButtonTapped))
        xButton.tintColor = .white
        navigationItem.rightBarButtonItem = xButton
    }
    
    @objc func xButtonkButtonTapped() {
        dismiss(animated: true)
    }
}
