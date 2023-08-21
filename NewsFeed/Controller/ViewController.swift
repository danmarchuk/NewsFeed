//
//  ViewController.swift
//  NewsFeed
//
//  Created by Данік on 09/08/2023.
//

import UIKit
import SnapKit
import CoreData
import Reachability

class ViewController: UIViewController, UICollectionViewDelegate {
    
    private let mainView = MainView()
    private var articles: [Article] = []
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var collectionView: UICollectionView!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    private func initialSetup() {
        configureCollectionView()
        setupRefreshControll()
        addElements()
        setupNavbar()
        setupTabBar()
        view.backgroundColor = K.backgroundGray
        parseXmls()
    }
    
    private func internetIsUnavailable() {
        // if there is no internet load from the memory
        loadArticlesFromCoreData()
        if articles.isEmpty {
            // if there are no internet and no saved core data
            displayNoInternetMessage()
        } else {
            collectionView.reloadData()
        }
    }
    
    private func displayNoInternetMessage() {
        let alert = UIAlertController(title: "No Internet Connection", message: "Please find an internet connection.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func isInternetAvailable() -> Bool {
        let reachability = try! Reachability()
        return reachability.connection != .unavailable
    }
    
    private func parseXmls() {
        
        if !isInternetAvailable() {
            internetIsUnavailable()
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        let manager = VergeParser()
        manager.fetchAndParseFeed { items in
            guard let feedItems = items else {return}
            
            for item in feedItems {
                self.articles.append(item)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        let nyTimesParser = NYTimesParser()
        nyTimesParser.fetchAndParseFeed { items in
            guard let feedItems = items else {return}
            
            for item in feedItems {
                self.articles.append(item)
            }
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        let voxParser = VoxParser()
        voxParser.fetchAndParseFeed { items in
            if let feedItems = items {
                self.articles.append(contentsOf: feedItems)
                self.saveArticlesToCoreData()
                self.loadArticlesFromCoreData()
            }
            dispatchGroup.leave()
            
        }
        dispatchGroup.notify(queue: .main) {
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    private func setupRefreshControll() {
        collectionView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    @objc func refreshData(_ sender: UIRefreshControl) {
        parseXmls()
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
                return Article(title: entity.title ?? "", summary: entity.summary ?? "", pictureLink: entity.pictureLink ?? "", articleLink: entity.articleLink ?? "", datePublished: entity.datePublished ?? "", source: entity.source ?? "", isSaved: entity.isSaved )
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
        let fullNewsViewController = FullArticleViewController()
        let chosenNews = articles[indexPath.row]
        fullNewsViewController.theArticle = chosenNews
        fullNewsViewController.delegate = self
        
        let navController = UINavigationController(rootViewController: fullNewsViewController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
}

extension ViewController: FullNewsViewControllerDelegate {
    func didUpdateTheNews(_ fullNewsViewController: FullArticleViewController, theArticle: Article) {
        updateArticleInCoreData(theArticle)
        loadArticlesFromCoreData()
        collectionView.reloadData()
    }
}

