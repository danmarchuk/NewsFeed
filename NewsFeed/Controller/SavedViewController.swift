//
//  SavedViewController.swift
//  NewsFeed
//
//  Created by Данік on 10/08/2023.
//

import Foundation
import UIKit

class SavedViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem = UITabBarItem(tabBarSystemItem: .downloads, tag: 3)
        view.backgroundColor = K.backgroundGray    }
}
