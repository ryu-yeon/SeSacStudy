//
//  GenderViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class GenderViewController: BaseViewController {
    
    private let mainView = GenderView()
    private let viewModel = GenderViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        mainView.manButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.gender = 1
                vc.viewModel.fetch()
            }
            .disposed(by: disposeBag)
        
        mainView.womanButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.gender = 0
                vc.viewModel.fetch()
            }
            .disposed(by: disposeBag)
        
        viewModel.data
            .withUnretained(self)
            .bind { (vc, value) in
                if value == 1 {
                    vc.mainView.manButton.backgroundColor = .whiteGreen
                    vc.mainView.womanButton.backgroundColor = .clear
                } else if value == 0 {
                    vc.mainView.manButton.backgroundColor = .clear
                    vc.mainView.womanButton.backgroundColor = .whiteGreen
                }
                vc.mainView.nextButton.backgroundColor = .brandGreen
            }
            .disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                
            }
            .disposed(by: disposeBag)
    }
}
