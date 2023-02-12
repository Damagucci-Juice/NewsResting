//
//  TabBarViewController.swift
//  NewsResting
//
//  Created by YEONGJIN JANG on 2023/01/14.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUP()
    }
    
    private func setUP() {
        let newsVC = CategoriesViewController()
        let newsString = "news".localized()
        newsVC.tabBarItem = UITabBarItem(title: newsString, image: UIImage(systemName: "list.bullet"), tag: 0)
        let newsNavi = UINavigationController(rootViewController: newsVC)
        
        let settingsVC = SettingsViewController()
        settingsVC.tabBarItem = UITabBarItem(title: "settings".localized(), image: UIImage(systemName: "person.crop.circle"), tag: 1)
        let settingNavi = UINavigationController(rootViewController: settingsVC)
        
        self.viewControllers = [newsNavi, settingNavi]
//        self.viewControllers = [settingNavi]
    }
}
