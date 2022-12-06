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
                vc.mainView.numberTextField.setLine()
                vc.viewModel.code = value
                vc.viewModel.isValidNumber()
            }
            .disposed(by: disposeBag)
    }
    
    private func setCheckButton() {
        viewModel.vaild
            .asDriver(onErrorJustReturn: false)
            .map { $0 ? .brandGreen : .gray6 }
            .drive(mainView.checkButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        mainView.checkButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                if vc.viewModel.vaild.value {
                    if vc.viewModel.checkAuth() != nil {
                        vc.mainView.makeToast(FirebaseAuthStatusCode.Fail.message, duration: 1.0, position: .top)
                    } else {
                        vc.viewModel.checkUser()
                        vc.bindLoginCode()
                    }
                } else {
                    vc.mainView.makeToast(FirebaseAuthStatusCode.Fail.message, duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindLoginCode() {
        viewModel.loginCode
            .take(1)
            .asDriver(onErrorJustReturn: .UnknownError)
            .drive { [self] userStatusCode in
                switch userStatusCode {
                case .Success:
                    UserDefaultsHelper.standard.saveUser(user: viewModel.user)
                    goToVC(vc: MainTabBarController())
                    print("로그인 성공🟢")
                case .FirebaseTokenError:
                    print("Firebase Token Error🔴")
                case .NotSignupUser:
                    let nextVC = NicknameViewController()
                    nextVC.viewModel.profile = viewModel.profile
                    navigationController?.pushViewController(nextVC, animated: true)
                    print("미가입 유저😀")
                case .ServerError:
                    print("Server Error🔴")
                case .ClientError:
                    print("Client Error🔴")
                default:
                    break
                }
                
            }
            .disposed(by: disposeBag)
    }
    
    private func setResendButton() {
        mainView.resendButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.timer?.dispose()
                vc.setTimer()
                vc.mainView.numberTextField.textField.text = ""
                vc.viewModel.vaild.accept(false)
                vc.viewModel.requestAuth()
                vc.bindFirebaseCode()
            }
            .disposed(by: disposeBag)
    }
    
    private func bindFirebaseCode() {
        viewModel.firebaseCode
            .asDriver(onErrorJustReturn: .UnknownError)
            .drive { [self] firebaseStatusCode in
                switch firebaseStatusCode {
                case .Success:
                    mainView.makeToast(firebaseStatusCode.message, duration: 1.0, position: .top)
                    let nextVC = LoginCheckViewController()
                    navigationController?.pushViewController(nextVC, animated: true)
                    nextVC.viewModel.phoneNumber = viewModel.phoneNumber
                case .ManyTry:
                    mainView.makeToast(firebaseStatusCode.message, duration: 1.0, position: .top)
                default:
                    mainView.makeToast(FirebaseAuthStatusCode.UnknownError.message, duration: 1.0, position: .top)
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
            self.viewModel.vaild.accept(false)
            self.viewModel.timer?.dispose()
        })
    }
}

