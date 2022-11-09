//
//  LoginViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class LoginViewController: BaseViewController {
    
    private let mainView = LoginView()
    private let viewModel = LoginViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
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
                vc.viewModel.withHypen(number: value)
                vc.mainView.numberTextField.text = vc.viewModel.phoneNumber
            }
            .disposed(by: disposeBag)
        
        viewModel.valid
            .withUnretained(self)
            .bind { (vc, value) in
                vc.mainView.checkButton.backgroundColor = value ? .brandGreen : .gray6
            }
            .disposed(by: disposeBag)
        
        mainView.checkButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                if vc.viewModel.isValid {
                    let phoneNumber = vc.mainView.numberTextField.text ?? ""
                    vc.viewModel.firebaseAuthManager.sendSMS(phoneNumber: phoneNumber) { error in
                        if error != nil {
                            vc.mainView.makeToast("에러가 발생했습니다. 다시 시도해주세요", duration: 1.0, position: .top)
                        } else {
                            let nextVC = LoginCheckViewController()
                            vc.navigationController?.pushViewController(nextVC, animated: true)
                            nextVC.viewModel.phoneNumber = phoneNumber
                        }
                    }
                } else {
                    vc.mainView.makeToast("잘못된 전화번호 형식입니다.", duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.fetch()
    }
}
