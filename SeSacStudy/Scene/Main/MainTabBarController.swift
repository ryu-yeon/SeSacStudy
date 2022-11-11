//
//  MainTabBarController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarController()
        setTabBarAppearence()
    }
    
    private func configureTabBarController() {
        let firstVC = HomeViewController()
        firstVC.tabBarItem.title = "홈"
        firstVC.tabBarItem.image = UIImage(named: "home")
        
        let secondVC = ShopViewController()
        secondVC.tabBarItem.title = "새싹샵"
        secondVC.tabBarItem.image = UIImage(named: "shop")
        
        let thirdVC = FriendViewController()
        thirdVC.tabBarItem.title = "새싹친구"
        thirdVC.tabBarItem.image = UIImage(named: "friend")
        
        let fourthVC = MyInfoViewController()
        fourthVC.tabBarItem.title = "내정보"
        fourthVC.tabBarItem.image = UIImage(named: "my")
        
        setViewControllers([firstVC, secondVC, thirdVC, fourthVC], animated: true)
    }
    
    private func setTabBarAppearence() {
        let appearence = UITabBarAppearance()
        appearence.configureWithTransparentBackground()
        appearence.backgroundColor = .systemBackground
        tabBar.standardAppearance = appearence
        tabBar.scrollEdgeAppearance = appearence
        tabBar.tintColor = .brandGreen
    }
}
