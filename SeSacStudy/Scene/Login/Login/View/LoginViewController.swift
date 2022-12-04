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
        setTextField()
        setCheckButton()
    }
    
    private func setTextField() {
        mainView.numberTextField.textField.becomeFirstResponder()
        
        mainView.numberTextField.textField.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { (vc, value) in
                vc.mainView.numberTextField.setLine()
                vc.viewModel.withHypen(number: value)
            }
            .disposed(by: disposeBag)
        
        viewModel.text
            .asDriver(onErrorJustReturn: "")
            .drive(mainView.numberTextField.textField.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setCheckButton() {
        viewModel.valid
            .asDriver(onErrorJustReturn: false)
            .map { $0 ? .brandGreen : .gray6 }
            .drive(mainView.checkButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        mainView.checkButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _ ) in
                if vc.viewModel.valid.value {
                    vc.viewModel.requestAuth()
                    vc.bindFirebaseCode()
                } else {
                    vc.mainView.makeToast(FBAMessage.invaild.rawValue, duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindFirebaseCode() {
        viewModel.firebaseCode
            .take(1)
            .asDriver(onErrorJustReturn: .UnknownError)
            .drive { [self] statusCode in
                switch statusCode {
                case .Success:
                    mainView.makeToast(FBAMessage.start.rawValue, duration: 1.0, position: .top)
                    let nextVC = LoginCheckViewController()
                    navigationController?.pushViewController(nextVC, animated: true)
                    nextVC.viewModel.phoneNumber = viewModel.phoneNumber
                case .ManyTry:
                    mainView.makeToast(FBAMessage.manyTry.rawValue, duration: 1.0, position: .top)
                default:
                    mainView.makeToast(FBAMessage.error.rawValue, duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
    }
}
