//
//  LoginViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift

final class LoginViewController: BaseViewController {
    
    private let mainView = LoginView()
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        mainView.numberTextField.becomeFirstResponder()       
        
        mainView.numberTextField.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { (vc, value) in
                vc.mainView.lineView.backgroundColor = value != "" ? .black : .gray3
                vc.mainView.numberTextField.text = vc.viewModel.withHypen(number: value)
                let number = vc.mainView.numberTextField.text
                vc.viewModel.isValid = vc.viewModel.isValidPhone(number: number!)
                if vc.viewModel.isValid {
                    vc.mainView.checkButton.backgroundColor = .brandGreen
                } else {
                    vc.mainView.checkButton.backgroundColor = .gray6
                }
            }
            .disposed(by: disposeBag)
        
        mainView.checkButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                if vc.viewModel.isValid {
                    print("인증시작")
                    vc.viewModel.phoneNumber = vc.mainView.numberTextField.text ?? ""
                    vc.viewModel.sendSMS()
                    let nextVC = LoginCheckViewController()
                    vc.navigationController?.pushViewController(nextVC, animated: true)
                } else {
                    print("잘못된 요청")
                }
            }
            .disposed(by: disposeBag)
    }
}
