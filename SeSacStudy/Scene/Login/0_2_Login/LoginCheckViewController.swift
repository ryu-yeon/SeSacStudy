//
//  LoginCheckViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/08.
//

import UIKit

import Toast
import RxCocoa
import RxSwift

final class LoginCheckViewController: BaseViewController {
    
    private let mainView = LoginCheckView()
    let viewModel = LoginCheckViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainView.makeToast("전화 번호 인증 시작", duration: 1.0, position: .top)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.numberTextField.becomeFirstResponder()
        
        mainView.numberTextField.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { (vc, value) in
                vc.mainView.lineView.backgroundColor = value != "" ? .black : .gray3
                vc.viewModel.code = value
                vc.viewModel.isValidNumber()
                if vc.viewModel.isValid {
                    vc.mainView.checkButton.backgroundColor = .brandGreen
                } else {
                    vc.mainView.checkButton.backgroundColor = .gray6
                }
            }
            .disposed(by: disposeBag)
        
        mainView.resendButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.firebaseAuthManager.sendSMS(phoneNumber: vc.viewModel.phoneNumber) { error in
                    if error != nil {
                        self.mainView.makeToast("에러가 발생했습니다. 다시 시도해주세요", duration: 1.0, position: .top)
                    } else {
                        vc.mainView.makeToast("전화 번호 인증 시작", duration: 1.0, position: .top)
                    }
                }
            }
            .disposed(by: disposeBag)
        
        mainView.checkButton.rx.tap
            .bind { _ in
                if self.viewModel.isValid {
                    self.viewModel.firebaseAuthManager.checkCode(code: self.viewModel.code) { error in
                        if let error {
                            print(error.localizedDescription)
                            self.mainView.makeToast("전화 번호 인증 실패", duration: 1.0, position: .top)
                        } else {
                            let nextVC = NicknameViewController()
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }
                    }
                } else {
                    self.mainView.makeToast("전화 번호 인증 실패", duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
    }
}
