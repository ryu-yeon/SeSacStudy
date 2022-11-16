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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setBackButton()
        setTimer()
        setTextField()
        setCheckButton()
        setResendButton()
    }
    
    private func setTextField() {
        mainView.numberTextField.textField.becomeFirstResponder()
        
        mainView.numberTextField.textField.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { (vc, value) in
                vc.mainView.numberTextField.lineView.backgroundColor = value != "" ? .black : .gray3
                vc.viewModel.code = value
                vc.viewModel.isValidNumber()
                if vc.viewModel.isValid {
                    vc.mainView.checkButton.backgroundColor = .brandGreen
                } else {
                    vc.mainView.checkButton.backgroundColor = .gray6
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setCheckButton() {
        viewModel.vaild
            .bind { value in
                self.mainView.checkButton.backgroundColor = value ? .brandGreen : .gray6
            }
            .disposed(by: disposeBag)
        
        mainView.checkButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                if vc.viewModel.isValid {
                    vc.viewModel.firebaseAuthManager.checkCode(code: vc.viewModel.code) { error in
                        if error != nil {
                            vc.mainView.makeToast(FBAMessage.fail.rawValue, duration: 1.0, position: .top)
                        } else {
                            vc.viewModel.getPhoneNumber()
                            vc.viewModel.firebaseAuthManager.getIdToken { idToken in
                                if let idToken {
                                    vc.viewModel.apiService.login(idToken: idToken) { data, statusCode in
                                        vc.checkStatusCode(statusCode, data: data)
                                    }
                                }
                            }
                        }
                    }
                } else {
                    vc.mainView.makeToast(FBAMessage.fail.rawValue, duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func checkStatusCode(_ statusCode: Int, data: User?) {
        switch statusCode {
        case 200:
            print("로그인 성공🟢")
            print(data)
            goToVC(vc: MainTabBarController())
        case 401:
            print("Firebase Token Error🔴")
        case 406:
            print("미가입 유저😀")
            let nextVC = NicknameViewController()
            nextVC.viewModel.profile = self.viewModel.profile
            self.navigationController?.pushViewController(nextVC, animated: true)
        case 500:
            print("Server Error🔴")
        case 501:
            print("Client Error🔴")
        default:
            break
        }
    }
    
    private func setResendButton() {
        mainView.resendButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.timer?.dispose()
                vc.setTimer()
                vc.mainView.numberTextField.textField.text = ""
                vc.viewModel.vaild.onNext(false)
                vc.viewModel.firebaseAuthManager.sendSMS(phoneNumber: vc.viewModel.phoneNumber) { error, code  in
                    if error != nil {
                        if code == 17010 {
                            vc.mainView.makeToast(FBAMessage.manyTry.rawValue, duration: 1.0, position: .top)
                        } else {
                            vc.mainView.makeToast(FBAMessage.error.rawValue, duration: 1.0, position: .top)
                        }
                    } else {
                        vc.mainView.makeToast(FBAMessage.start.rawValue, duration: 1.0, position: .top)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setTimer() {
        let startTime = Date()
        
        viewModel.timer?.dispose()
        viewModel.timer = Observable<Int>.interval(
            .seconds(1),
            scheduler: MainScheduler.instance)
        .take(60)
        .withUnretained(self)
        .subscribe(onNext: { (vc, value) in
            let elapseSeconds = Date().timeIntervalSince(startTime)
            vc.mainView.timerLabel.text = "\(60 - Int(elapseSeconds))"
        }, onCompleted: {
            self.viewModel.vaild.onNext(false)
            self.viewModel.isValid = false
            self.viewModel.timer?.dispose()
        })
    }
}

