//
//  LoginViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/08.
//

import UIKit

import RxCocoa
import RxSwift
import RxKeyboard
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
        setTextField()
        setCheckButton()
        
        viewModel.fetch()
    }
    
    private func setTextField() {
        mainView.numberTextField.textField.becomeFirstResponder()
        
        mainView.numberTextField.textField.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { (vc, value) in
                vc.mainView.numberTextField.lineView.backgroundColor = value != "" ? .black : .gray3
                vc.viewModel.withHypen(number: value)
                vc.mainView.numberTextField.textField.text = vc.viewModel.phoneNumber
            }
            .disposed(by: disposeBag)
    }
    
    private func setCheckButton() {
        viewModel.valid
            .withUnretained(self)
            .bind { (vc, value) in
                vc.mainView.checkButton.backgroundColor = value ? .brandGreen : .gray6
            }
            .disposed(by: disposeBag)
        
        mainView.checkButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _ ) in
                if vc.viewModel.isValid {
                    let phoneNumber = vc.mainView.numberTextField.textField.text ?? ""
                    vc.viewModel.firebaseAuthManager.sendSMS(phoneNumber: phoneNumber) { error, code  in
                        if error != nil {
                            if code == FBAError.manyTry.rawValue {
                                vc.mainView.makeToast(FBAMessage.manyTry.rawValue, duration: 1.0, position: .top)
                            } else {
                                vc.mainView.makeToast(FBAMessage.error.rawValue, duration: 1.0, position: .top)
                            }
                        } else {
                            vc.mainView.makeToast(FBAMessage.start.rawValue, duration: 1.0, position: .top)
                            let nextVC = LoginCheckViewController()
                            vc.navigationController?.pushViewController(nextVC, animated: true)
                            nextVC.viewModel.phoneNumber = phoneNumber
                        }
                    }
                } else {
                    vc.mainView.makeToast(FBAMessage.invaild.rawValue, duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
    }
}
