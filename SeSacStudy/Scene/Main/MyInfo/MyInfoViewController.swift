//
//  MyInfoViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import UIKit

import RxCocoa
import RxSwift

final class MyInfoViewController: BaseViewController {
    
    private let mainView = MyInfoView()
    let viewModel = MyInfoViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
