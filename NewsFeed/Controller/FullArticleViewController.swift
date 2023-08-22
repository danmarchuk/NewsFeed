//
//  FullNewsViewController.swift
//  NewsFeed
//
//  Created by Данік on 18/08/2023.
//

import Foundation
import UIKit
import CoreData
import GoogleMobileAds

protocol FullNewsViewControllerDelegate {
    func didUpdateTheNews(_ fullNewsViewController: FullArticleViewController, theArticle: Article)
}

final class FullArticleViewController: UIViewController  {
    // Google ads
    private var interstitial: GADInterstitialAd?
    
    let defaults = UserDefaults.standard

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
        setupInterstitialAdd()
        setupNavigationBar()
        setupReadInSourceButton()
        displayTheAddEachSecondTime()
    }
    
    private func displayTheAddEachSecondTime() {
        let currentCount = defaults.integer(forKey: "openCount") + 1
        defaults.set(currentCount, forKey: "openCount")
        
        let openCount = defaults.integer(forKey: "openCount")
        if openCount>=2 {
            defaults.set(0, forKey: "openCount")
            DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                self.showAnAdd()
            }
        }
    }
    
    private func setupReadInSourceButton() {
        fullArticleView.readInSourceButton.addTarget(self, action: #selector(readInSourceButtonTapped(_:)), for: .touchUpInside)
    }
    
    private func setupInterstitialAdd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-5950465833598200/1473978820",
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
            interstitial?.fullScreenContentDelegate = self}
        )
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
        
        backButton.accessibilityIdentifier = "backArrowButton"
        bookmarkButton.accessibilityIdentifier = "bookmarkButton"
        
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

extension FullArticleViewController: GADFullScreenContentDelegate {
    private func showAnAdd() {
        if interstitial != nil {
            print("AD isn't nil")
            interstitial?.present(fromRootViewController: self)
        } else {
          print("Ad wasn't ready")
        }
    }
    
    /// Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("Ad did fail to present full screen content.")
    }

    /// Tells the delegate that the ad will present full screen content.
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad will present full screen content.")
    }

    /// Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did dismiss full screen content.")
    }
    
}
