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
        
        if UserDefaults.standard.bool(forKey: "start") {
            checkUser()
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
                self?.goToVC(vc: LoginViewController())
            }
        }
    }
    
    private func checkStatusCode(_ statusCode: Int, data: User?) {
        switch statusCode {
        case 200:
            print("로그인 성공🟢")
            goToVC(vc: MainTabBarController())
            print(data)
        case 401:
            print("Firebase Token Error🔴")
        case 406:
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
