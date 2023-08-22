//
//  SearchViewController.swift
//  NewsFeed
//
//  Created by Данік on 10/08/2023.
//

import Foundation
import UIKit

final class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        view.backgroundColor = K.backgroundGray
    }
    
}
