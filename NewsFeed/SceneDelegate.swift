//
//  SceneDelegate.swift
//  NewsFeed
//
//  Created by Данік on 09/08/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Create instances of the view controllers wrapped in navigation controllers
        let firstVC = UINavigationController(rootViewController: ViewController())
        let secondVC = UINavigationController(rootViewController: SearchViewController())
        let thirdVC = UINavigationController(rootViewController: BellViewController())
        let fourthVC = UINavigationController(rootViewController: SavedViewController())
        
        firstVC.tabBarItem.image = UIImage(named: "homeImage")?.withRenderingMode(.alwaysTemplate)
        secondVC.tabBarItem.image = UIImage(named: "searchImage")?.withRenderingMode(.alwaysTemplate)
        thirdVC.tabBarItem.image = UIImage(named: "bellImage")?.withRenderingMode(.alwaysTemplate)
        fourthVC.tabBarItem.image = UIImage(named: "savedImage")?.withRenderingMode(.alwaysTemplate)

        // Set tab bar items, images, etc. for each navigation controller here if needed
        let tabBarVC = UITabBarController()
        tabBarVC.viewControllers = [firstVC, secondVC, thirdVC, fourthVC]
        tabBarVC.tabBar.tintColor = .red // Or some other contrasting color
        tabBarVC.tabBar.unselectedItemTintColor = .white // Or any other color
        tabBarVC.tabBar.barTintColor = K.backgroundGray
        tabBarVC.tabBar.isTranslucent = false


        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarVC
        window.backgroundColor = K.backgroundGray
        self.window = window
        window.makeKeyAndVisible()

    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

