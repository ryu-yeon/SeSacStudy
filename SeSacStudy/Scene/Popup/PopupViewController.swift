//
//  PopupViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/15.
//

import UIKit

import RxCocoa
import RxSwift

final class PopupViewController: BaseViewController {
    
    private let mainView = PopupView()
    private let disposeBag = DisposeBag()
    
    let apiService = APIService()
    let firebaseAuthManager = FirebaseAuthManager()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCancelButton()
    }
    
    func setCancelButton() {
        mainView.cancleButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.dismiss(animated: true)
            }.disposed(by: disposeBag)
    }
    
    func setTitle(title: String) {
        mainView.titleLabel.text = title
    }
    
    func setSubtitle(subtitle: String) {
        mainView.subtitleLabel.text = subtitle
    }
    
    func withDraw() {
        mainView.okButton.addTarget(self, action: #selector(okButtonClicked), for: .touchUpInside)
    }
    
    @objc func okButtonClicked() {
        let idToken = UserDefaultsHelper.standard.idToken
        apiService.withDraw(idToken: idToken) { [weak self] statusCode in
            self?.checkStatusCode(statusCode)
        }
    }
    
    private func checkStatusCode(_ statusCode: Int) {
        switch statusCode {
        case 200:
            goToVC(vc: OnboardingViewController())
            print("탈퇴 성공🟢")
        case 401:
            firebaseAuthManager.getIdToken { [weak self] idToken in
                if let idToken {
                    self?.apiService.withDraw(idToken: idToken) { statusCode in
                        self?.checkStatusCode(statusCode)
                    }
                }
            }
            print("Firebase Token Error🔴")
        case 406:
            goToVC(vc: OnboardingViewController())
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
