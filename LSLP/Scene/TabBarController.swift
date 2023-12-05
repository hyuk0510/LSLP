//
//  TabBarController.swift
//  LSLP
//
//  Created by 선상혁 on 2023/12/03.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let firstVC = UINavigationController(rootViewController: MainViewController())
        let secondVC = UINavigationController(rootViewController: UserProfileViewController())
        
        firstVC.tabBarItem = UITabBarItem(title: "검색", image: UIImage(systemName: "magnifyingglass"), tag: 1)
        secondVC.tabBarItem = UITabBarItem(title: "프로필", image: UIImage(systemName: "person"), tag: 2)
        tabBar.tintColor = .label
        
        viewControllers = [firstVC, secondVC]
    }
}
