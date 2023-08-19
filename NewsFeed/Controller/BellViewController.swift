//
//  BellViewController.swift
//  NewsFeed
//
//  Created by Данік on 10/08/2023.
//

import Foundation
import UIKit

class BellViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 2)
        view.backgroundColor = K.backgroundGray    }
}
