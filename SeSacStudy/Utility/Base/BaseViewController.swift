//
//  BaseViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/07.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.setBackIndicatorImage(UIImage(named: "left"), transitionMaskImage: UIImage(named: "left"))
        appearance.backgroundColor = .white
        appearance.shadowColor = .gray6
        appearance.shadowImage = UIImage()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance

        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
        UINavigationBar.appearance().backIndicatorImage = UIImage(named: "left")
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "left")
    }
    
    func goToVC(vc: UIViewController) {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        sceneDelegate?.window?.rootViewController = vc
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}
