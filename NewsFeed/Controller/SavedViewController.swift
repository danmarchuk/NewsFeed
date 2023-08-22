//
//  SavedViewController.swift
//  NewsFeed
//
//  Created by Данік on 10/08/2023.
//

import Foundation
import UIKit

final class SavedViewController: UIViewController {
    
    private var collectionView: UICollectionView!

    
    var savedArticles: [Article] = []
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 3)
        view.backgroundColor = K.backgroundGray
        fetchArticles()
        configureCollectionView()
        addElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedArticles.removeAll()
        fetchArticles()
    }
    
    func fetchArticles() {
        do {
            guard let articleEntities = try context?.fetch(ArticleEntity.fetchRequest()) else {return}
            for articleEntity in articleEntities {
                if articleEntity.isSaved {
                    let article = Article(title: articleEntity.title ?? "", summary: articleEntity.summary ?? "", pictureLink: articleEntity.pictureLink ?? "", articleLink: articleEntity.articleLink ?? "", datePublishedString: articleEntity.datePublishedString ?? "", source: articleEntity.source ?? "", isSaved: articleEntity.isSaved, datePublished: articleEntity.datePublished ?? Date())
                    savedArticles.append(article)
                }
            }
        } catch {
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addElements() {
        view.addSubview(collectionView)
        
        // Setup collectionView constraints
        collectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
}

extension SavedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        savedArticles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            return UICollectionViewCell()
        }
        let currentArticle = savedArticles[indexPath.row]
        cell.configure(withArticle: currentArticle, dateAndSource: "\(currentArticle.source) - \(currentArticle.datePublishedString)")
        
        cell.bookmarkButton.tag = indexPath.row
                
        if currentArticle.isSaved == true {
            cell.bookmarkButton.tintColor = .red
        } else {
            cell.bookmarkButton.tintColor = .white
        }
        
        cell.imageView.isHidden = true
    
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SavedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 20
        }
        return CGSize(width: view.frame.size.width, height: view.frame.size.height / 5)
    }
}
