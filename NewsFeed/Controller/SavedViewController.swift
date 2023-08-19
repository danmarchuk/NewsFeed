//
//  SavedViewController.swift
//  NewsFeed
//
//  Created by Данік on 10/08/2023.
//

import Foundation
import UIKit

class SavedViewController: UIViewController {
    
    let viewController = ViewController()
    
    var savedArticles: [Article] = []
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 3)
        view.backgroundColor = K.backgroundGray
        fetchArticles()
    }
    
    func fetchArticles() {
        do {
            guard let articleEntities = try context?.fetch(ArticleEntity.fetchRequest()) else {return}
            for articleEntity in articleEntities {
                if articleEntity.isSaved {
                    let article = Article(title: articleEntity.title ?? "", summary: articleEntity.summary ?? "", pictureLink: articleEntity.pictureLink ?? "", articleLink: articleEntity.articleLink ?? "", datePublished: articleEntity.datePublished ?? "", source: articleEntity.source ?? "")
                    savedArticles.append(article)
                    print(article.title)
                }
            }
        } catch {
            
        }
    }
}
