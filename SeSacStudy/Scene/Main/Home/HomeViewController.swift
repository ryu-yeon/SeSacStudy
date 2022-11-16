//
//  HomeViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import UIKit

import RxCocoa
import RxSwift

final class HomeViewController: BaseViewController {
    
    private let mainView = HomeView()
    let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
