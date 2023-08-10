//
//  ViewController.swift
//  NewsFeed
//
//  Created by Данік on 09/08/2023.
//

import UIKit
import SnapKit

class ViewController: UIViewController, UICollectionViewDelegate {

    private let mainView = MainView()
    
    private var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureCollectionView()
        addElements()
        setupNavbar()
        setupTabBar()
        view.backgroundColor = K.backgroundGray
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
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell else {
            return UICollectionViewCell()
        }
        cell.configure(withTitle: "THIS IS THE TITLE THIS IS THE TITLE THIS IS THE TITLE THIS IS THE TITLE THIS IS THE TITLE THIS IS THE TITLE", dateAndSource: "fable - today", withImage: "https://cdn.cnn.com/cnnnext/dam/assets/221117142556-the-assignment-with-audie-cornish-live-video.jpg")
        cell.backgroundColor = .clear
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

