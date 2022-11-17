//
//  SetSearchViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/17.
//

import Foundation

final class SetSearchViewController: BaseViewController {
    
    private let mainView = SetSearchView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setBackButton()
        
    }
    
    override func setNavigationBar() {
        //서치
    }
}
