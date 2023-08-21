//
//  FullNewsViewController.swift
//  NewsFeed
//
//  Created by Данік on 18/08/2023.
//

import Foundation
import UIKit
import CoreData

protocol FullNewsViewControllerDelegate {
    func didUpdateTheNews(_ fullNewsViewController: FullArticleViewController, theArticle: Article)
}

class FullArticleViewController: UIViewController  {
    
    private var backButton: UIBarButtonItem!
    private var bookmarkButton: UIBarButtonItem!
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    let fullArticleView = FullArticleView()
    var theArticle: Article?
    
    var delegate: FullNewsViewControllerDelegate?
    
    override func loadView() {
        view = fullArticleView
        guard let unwrappedNews = theArticle else {return}
        fullArticleView.configure(dateAndSource: "\(unwrappedNews.source) - \(unwrappedNews.datePublishedString)", withTitle: unwrappedNews.title, withUrl: unwrappedNews.articleLink, withImageUrl: unwrappedNews.pictureLink, withDescription: unwrappedNews.summary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigationBar()
        setupReadInSourceButton()
    }
    
    func setupReadInSourceButton() {
        fullArticleView.readInSourceButton.addTarget(self, action: #selector(readInSourceButtonTapped(_:)), for: .touchUpInside)
    }
    
    @objc func readInSourceButtonTapped (_ sender: UIButton) {
        guard let unwrappedNews = theArticle else {return}
        guard let linkToTheArticleUrl = URL(string: unwrappedNews.articleLink) else {return}
        let webViewVc = WebViewController(url: linkToTheArticleUrl)

        let navController = UINavigationController(rootViewController: webViewVc)
        navController.navigationBar.backgroundColor = K.backgroundGray
        navController.modalPresentationStyle = .popover
        present(navController, animated: true)
    }
    
    func setupNavigationBar() {
        guard let unwrappedNews = theArticle else {return}
        backButton = UIBarButtonItem(image: UIImage(named: "backArrow"), style: .plain, target: self, action: #selector(backButtonTapped))
        bookmarkButton = UIBarButtonItem(image: UIImage(named: "savedImage"), style: .plain, target: self, action: #selector(bookmarkButtonTapped))
        
        backButton.tintColor = .white
        bookmarkButton.tintColor = unwrappedNews.isSaved ? .red : .white
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.rightBarButtonItem = bookmarkButton
    }
    
    @objc func backButtonTapped() {
        guard let unwrappedArticle = theArticle else {return}
        delegate?.didUpdateTheNews(self, theArticle: unwrappedArticle)
        dismiss(animated: true)
    }
    
    
    @objc func bookmarkButtonTapped() {
        guard var unwrappedNews = theArticle else {return}

        unwrappedNews.isSaved.toggle()
        theArticle = unwrappedNews
        
        bookmarkButton.tintColor =  unwrappedNews.isSaved ? .red : .white
        
    }
}
