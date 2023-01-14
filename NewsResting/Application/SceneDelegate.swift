//
//  SceneDelegate.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let tabBarController = TabBarViewController()
        window.rootViewController = tabBarController
        
        self.window = window
        window.makeKeyAndVisible()
    }
    
    
}

