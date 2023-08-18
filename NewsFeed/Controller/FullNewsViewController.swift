//
//  FullNewsViewController.swift
//  NewsFeed
//
//  Created by Данік on 18/08/2023.
//

import Foundation
import UIKit

class FullNewsViewController: UIViewController  {
    
    private var backButton: UIBarButtonItem!
    private var bookmarkButton: UIBarButtonItem!
    
    let fullNewsView = NewsFullView()
    var theNews: ArticleInfo = ArticleInfo(title: "", summary: "", pictureLink: "", articleLink: "", datePublished: "", source: "")
    
    override func loadView() {
        view = fullNewsView
        fullNewsView.configure(dateAndSource: "\(theNews.source) - \(theNews.datePublished)", withTitle: theNews.title, withUrl: theNews.articleLink, withImageUrl: theNews.pictureLink, withDescription: theNews.summary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        backButton = UIBarButtonItem(image: UIImage(named: "backArrow"), style: .plain, target: self, action: #selector(backButtonTapped))
        bookmarkButton = UIBarButtonItem(image: UIImage(named: "savedImage"), style: .plain, target: self, action: #selector(bookmarkButtonTapped))
        
        backButton.tintColor = .white
        bookmarkButton.tintColor = .white
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = bookmarkButton
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func bookmarkButtonTapped() {
        print("bookmarkButtonTapped")
    }
}
