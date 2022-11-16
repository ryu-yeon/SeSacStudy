//
//  GenderViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class GenderViewController: BaseViewController {
    
    private let mainView = GenderView()
    let viewModel = GenderViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setBackButton()
        setGenderButton()
        setNextButton()
        
        viewModel.fetch()
    }
    
    private func setGenderButton() {
        mainView.manButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.profile?.gender = 1
                vc.viewModel.fetch()
            }
            .disposed(by: disposeBag)
        
        mainView.womanButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.profile?.gender = 0
                vc.viewModel.fetch()
            }
            .disposed(by: disposeBag)
        
        viewModel.data
            .withUnretained(self)
            .bind { (vc, value) in
                if value == 1 {
                    vc.mainView.manButton.backgroundColor = .whiteGreen
                    vc.mainView.womanButton.backgroundColor = .clear
                } else if value == 0 {
                    vc.mainView.manButton.backgroundColor = .clear
                    vc.mainView.womanButton.backgroundColor = .whiteGreen
                }
                vc.mainView.nextButton.backgroundColor = .brandGreen
            }
            .disposed(by: disposeBag)
    }
    
    private func setNextButton() {
        mainView.nextButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                guard let profile = vc.viewModel.profile else { return }
                print(profile)
                if profile.gender >= 0 {
                    let idToken = UserDefaultsHelper.standard.idToken
                    vc.viewModel.apiService.signup(idToken: idToken, profile: profile) { statusCode in
                        vc.checkStatusCode(statusCode)
                    }
                } else {
                    vc.mainView.makeToast("성별을 선택해 주세요.", duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func checkStatusCode(_ statusCode: Int) {
        switch statusCode {
        case 200:
            print("회원가입 성공🟢")
            let idToken = UserDefaultsHelper.standard.idToken
            viewModel.apiService.login(idToken: idToken) { data, statusCode in
                if data != nil {
                    UserDefaultsHelper.standard.saveUser(user: data)
                }
            }
            goToVC(vc: MainTabBarController())
        case 201:
            print("이미 가입한 유저")
        case 202:
            print("사용할 수 없는 닉네임")
            guard let viewControllerStack = self.navigationController?.viewControllers else { return }
                for viewController in viewControllerStack {
                    if let nicknameVC = viewController as? NicknameViewController {
                        nicknameVC.viewModel.profile = self.viewModel.profile
                        self.navigationController?.popToViewController(nicknameVC, animated: true)
                    }
                }
        case 401:
            print("Firebase Token Error🔴")
            guard let profile = self.viewModel.profile else { return }
            self.viewModel.firebaseAuthManager.getIdToken { [weak self] idToken in
                if let idToken {
                    self?.viewModel.apiService.signup(idToken: idToken, profile: profile, complitionHandler: { [weak self] status in
                        self?.checkStatusCode(statusCode)
                    })
                }
            }
        case 500:
            print("Server Error🔴")
        case 501:
            print("Client Error🔴")
        default:
            break
        }
    }
}
