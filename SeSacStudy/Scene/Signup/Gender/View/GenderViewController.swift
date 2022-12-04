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
    }
    
    private func setGenderButton() {
        mainView.manButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.profile?.gender = Gender.Man
                vc.viewModel.gender.accept(Gender.Man)
            }
            .disposed(by: disposeBag)
        
        mainView.womanButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.profile?.gender = Gender.Woman
                vc.viewModel.gender.accept(Gender.Woman)
            }
            .disposed(by: disposeBag)
        
        viewModel.gender
            .asDriver(onErrorJustReturn: .Nothing)
            .drive { [self] gender in
                switch gender {
                case .Man:
                    mainView.manButton.backgroundColor = .whiteGreen
                    mainView.womanButton.backgroundColor = .clear
                    mainView.nextButton.backgroundColor = .brandGreen
                case .Woman:
                    mainView.manButton.backgroundColor = .clear
                    mainView.womanButton.backgroundColor = .whiteGreen
                    mainView.nextButton.backgroundColor = .brandGreen
                default: break
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    private func setNextButton() {
        mainView.nextButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                guard let profile = vc.viewModel.profile else { return }
                print(profile)
                if profile.gender != .Nothing {
                    vc.viewModel.signup()
                    vc.bindSignupCode()
                } else {
                    vc.mainView.makeToast("성별을 선택해 주세요.", duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
    }

    private func bindSignupCode() {
        viewModel.signupCode
            .take(1)
            .asDriver(onErrorJustReturn: .UnknownError)
            .drive { [self] userStatusCode in
                switch userStatusCode {
                case .Success:
                    let idToken = UserDefaultsHelper.standard.idToken
                    viewModel.userService.login(idToken: idToken) { user, statusCode in
                        if user != nil {
                            UserDefaultsHelper.standard.saveUser(user: user)
                            self.goToVC(vc: MainTabBarController())
                        }
                    }
                    print("회원가입 성공🟢")
                case .SignInUser:
                    print("이미 가입한 유저")
                case .InvaliedNickName:
                    guard let viewControllerStack = self.navigationController?.viewControllers else { return }
                    for viewController in viewControllerStack {
                        if let nicknameVC = viewController as? NicknameViewController {
                            nicknameVC.viewModel.profile = self.viewModel.profile
                            self.navigationController?.popToViewController(nicknameVC, animated: true)
                        }
                    }
                    print("사용할 수 없는 닉네임🟠")
                case .FirebaseTokenError:
                    print("Firebase Token Error🔴")
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
