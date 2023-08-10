//
//  ViewController.swift
//  NewsFeed
//
//  Created by Данік on 09/08/2023.
//

import UIKit

class ViewController: UIViewController {

    private let mainView = MainView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavbar()
        setupTabBar()
        view.backgroundColor = K.backgroundGray
    }


    private func setupNavbar() {
        navigationItem.titleView = mainView.navbarLabel
//        let onePixelImage = UIImage(color: .white, size: CGSize(width: 1, height: 1))
//        navigationController?.navigationBar.backgroundColor = .blue
//        navigationController?.navigationBar.shadowImage = onePixelImage
//        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.showNavBarSeparator()
    }
    
    private func setupTabBar() {
        tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
    }
}

