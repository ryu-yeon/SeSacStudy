//
//  SplashViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import UIKit

final class SplashViewController: BaseViewController {

    private let mainView = SplashView()
    private let viewModel = SplashViewModel()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaultsHelper.standard.start {
            checkUser()
//            goToVC(vc: UINavigationController(rootViewController: EmailViewController()))
        } else {
            goToVC(vc: OnboardingViewController())
        }
    }
    
    private func checkUser() {
        viewModel.firebaseAuthManager.getIdToken { [weak self] idToken in
            if let idToken {
                self?.viewModel.apiService.login(idToken: idToken) { data, statusCode in
                    self?.checkStatusCode(statusCode, data: data)
                }
            } else {
                self?.goToVC(vc: UINavigationController(rootViewController: LoginViewController()))
            }
        }
    }
    
    private func checkStatusCode(_ statusCode: Int, data: User?) {
        switch statusCode {
        case 200:
            print("로그인 성공🟢")
            UserDefaultsHelper.standard.saveUser(user: data)
            print(data)
            goToVC(vc: MainTabBarController())
        case 401:
            print("Firebase Token Error🔴")
        case 406:
            goToVC(vc: UINavigationController(rootViewController: LoginViewController()))
            print("미가입 유저😀")
        case 500:
            print("Server Error🔴")
        case 501:
            print("Client Error🔴")
        default:
            break
        }
    }
}
