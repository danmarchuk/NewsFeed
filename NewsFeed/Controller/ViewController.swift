//
//  ViewController.swift
//  NewsFeed
//
//  Created by Данік on 09/08/2023.
//

import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate {
    
    private let mainView = MainView()
    
    private var collectionView: UICollectionView!
    
    private var articles: [Article] = []
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    private func initialSetup() {
        configureCollectionView()
        addElements()
        setupNavbar()
        setupTabBar()
        view.backgroundColor = K.backgroundGray
        parseXmls()
    }
    
    private func parseXmls() {
        guard articles.isEmpty else {
            loadArticlesFromCoreData()
            return}
        let manager = VergeParser()
        manager.fetchAndParseFeed { items in
            guard let feedItems = items else {return}
            
            for item in feedItems {
                self.articles.append(item)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        let nyTimesParser = NYTimesParser()
        
        nyTimesParser.fetchAndParseFeed { items in
            guard let feedItems = items else {return}
            
            for item in feedItems {
                self.articles.append(item)
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        let voxParser = VoxParser()
        
        voxParser.fetchAndParseFeed { items in
            guard let feedItems = items else {return}
            
            for item in feedItems {
                self.articles.append(item)
            }
            
            self.saveArticlesToCoreData()
            self.loadArticlesFromCoreData()
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private func addElements() {
        view.addSubview(collectionView)
        
        // Setup collectionView constraints
        collectionView.snp.makeConstraints { make in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    private func setupNavbar() {
        navigationItem.titleView = mainView.navbarLabel
        let onePixelImage = UIImage(color: .white, size: CGSize(width: 1, height: 0.2))
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = K.backgroundGray
        navigationController?.navigationBar.tintColor = K.backgroundGray
        navigationController?.navigationBar.shadowImage = onePixelImage
        //        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
    }
    
    
    private func setupTabBar() {
        tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
    }
    
    @objc func bookmarkButtonTappedAt(index: Int, sender: UIButton) {
        articles[index].isSaved.toggle()
        
        sender.tintColor =  articles[index].isSaved ? .red : .white
        
        updateArticleInCoreData(articles[index])
    }
    
    func updateArticleInCoreData(_ article: Article) {
        guard let context = self.context else {return}
        
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "title == %@", article.title)
        do {
            let fetchedArticles = try context.fetch(fetchRequest)
            
            if let existingArticle = fetchedArticles.first {
                existingArticle.isSaved = article.isSaved
                try context.save()
            }
        } catch {
        }
    }
    
    func loadArticlesFromCoreData() {
        guard let context = context else {return}
        
        let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
        do {
            let fetchedArticles = try context.fetch(fetchRequest)
            articles = fetchedArticles.map({ entity in
                return Article(title: entity.title ?? "", summary: entity.summary ?? "", pictureLink: entity.pictureLink ?? "", articleLink: entity.articleLink ?? "", datePublished: entity.datePublished ?? "", source: entity.source ?? "")
            })
        } catch {
        }
    }
    
    func saveArticlesToCoreData() {
        guard let context = context else {return}
        
        for article in articles {
            let fetchRequest: NSFetchRequest<ArticleEntity> = ArticleEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@", article.title)
            
            let existingArticles = try? context.fetch(fetchRequest)
            if existingArticles?.isEmpty ?? true {
                
                let articleEntity = ArticleEntity(context: context)
                articleEntity.title = article.title
                articleEntity.summary = article.summary
                articleEntity.datePublished = article.datePublished
                articleEntity.isSaved = article.isSaved
                articleEntity.pictureLink = article.pictureLink
                articleEntity.source = article.source
                articleEntity.articleLink = article.articleLink
                do {
                    try context.save()
                }
                catch {
                }
            }
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            return UICollectionViewCell()
        }
        cell.configure(withArticle: articles[indexPath.row], dateAndSource: "\(articles[indexPath.row].source) - \(articles[indexPath.row].datePublished)")
        
        cell.bookmarkButton.tag = indexPath.row
        
        if articles[indexPath.row].isSaved {
            cell.bookmarkButton.tintColor = .red
            print(articles[indexPath.row].isSaved)
        } else {
            cell.bookmarkButton.tintColor = .white
        }
        
        cell.bookmarkTapped = { [weak self] index in
            self?.bookmarkButtonTappedAt(index: index, sender: cell.bookmarkButton)
            
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.minimumLineSpacing = 20
        }
        return CGSize(width: view.frame.size.width, height: view.frame.size.height / 1.5)
    }
}

// MARK: - didSelectRowAt

extension ViewController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullNewsViewController = FullNewsViewController()
        let chosenNews = articles[indexPath.row]
        fullNewsViewController.theNews = chosenNews
        
        let navController = UINavigationController(rootViewController: fullNewsViewController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

