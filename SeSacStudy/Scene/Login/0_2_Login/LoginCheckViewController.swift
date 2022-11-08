//
//  LoginCheckViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift

final class LoginCheckViewController: BaseViewController {
    
    private let mainView = LoginCheckView()
    private let viewModel = LoginCheckViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.numberTextField.becomeFirstResponder()
        
        mainView.numberTextField.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { (vc, value) in
                vc.mainView.lineView.backgroundColor = value != "" ? .black : .gray3

            }
            .disposed(by: disposeBag)
        
        mainView.checkButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in

            }
            .disposed(by: disposeBag)
    }
}
