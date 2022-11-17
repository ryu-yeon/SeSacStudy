//
//  ChatViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/17.
//

import UIKit

final class ChatViewController: BaseViewController {
    
    private let mainView = ChatView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setBackButton()
    }
    
    override func setNavigationBar() {
        navigationItem.title = "채팅"
    }
}
