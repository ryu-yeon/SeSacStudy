//
//  SplashViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import UIKit

import RxCocoa
import RxSwift

final class SplashViewController: BaseViewController {

    private let mainView = SplashView()
    private let viewModel = SplashViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindStatusCode()
        
        viewModel.checkUser {
            self.goToVC(vc: OnboardingViewController())
        }
    }
    
    private func bindStatusCode() {
        viewModel.statusCode
            .withUnretained(self)
            .bind { (vc, userStatusCode) in
                switch userStatusCode {
                case .Success:
                    UserDefaultsHelper.standard.saveUser(user: vc.viewModel.user)
                    vc.goToVC(vc: MainTabBarController())
                    print("로그인 성공🟢")
                case .FirebaseTokenError:
                    vc.goToVC(vc: UINavigationController(rootViewController: LoginViewController()))
                    print("Firebase Token Error🔴")
                case .NotSignupUser:
                    vc.goToVC(vc: UINavigationController(rootViewController: LoginViewController()))
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
}
