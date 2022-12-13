//
//  PopupViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/15.
//

import UIKit

import RxCocoa
import RxSwift
import Toast
import SnapKit

final class PopupViewController: BaseViewController {
    
    private let mainView = PopupView()
    private let disposeBag = DisposeBag()
    
    let apiService = APIService()
    let firebaseAuthManager = FirebaseAuthManager()
    
    var uid = ""
    
    var nickname = ""
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCancelButton()
        setTapGesture()
    }
    
    private func setTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap))
        tap.cancelsTouchesInView = false
        mainView.addGestureRecognizer(tap)
    }
    
    @objc func tap() {
        self.dismiss(animated: true)
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
        mainView.okButton.addTarget(self, action: #selector(withDrawButtonClicked), for: .touchUpInside)
    }
    
    @objc func withDrawButtonClicked() {
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
    
    func studyRequest() {
        mainView.subtitleLabel.textColor = .gray7
        mainView.okButton.addTarget(self, action: #selector(requestButtonClicked), for: .touchUpInside)
        mainView.popupContainer.snp.updateConstraints { make in
            make.height.equalTo(178)
        }
        mainView.subtitleLabel.snp.updateConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    @objc func requestButtonClicked() {
        let idToken = UserDefaultsHelper.standard.idToken
        apiService.requestStudy(idToken: idToken, uid: uid) { [weak self] statusCode in
            self?.checkStatusCode2(statusCode)
        }
    }
    
    private func checkStatusCode2(_ statusCode: Int) {
        guard let pvc = self.presentingViewController else { return }
        switch statusCode {
        case 200:
            dismiss(animated: true) {
                pvc.view.makeToast("스터디 요청을 보냈습니다", duration: 1.0, position: .top)
            }
            print("스터디 요청 성공🟢")
        case 201:
            // accept 호출
            print("상대방이 이미 나에게 스터디 요청한 상태🟠")
        case 202:
            dismiss(animated: true) {
                pvc.view.makeToast("상대방이 스터디 찾기를 그만두었습니다", duration: 1.0, position: .top)
            }
            print("상대방이 새싹 찾기를 중단한 상태🟠")
        case 401:
            firebaseAuthManager.getIdToken { idToken in
                if let idToken {
                    self.apiService.requestStudy(idToken: idToken, uid: self.uid) { statusCode in
                        self.checkStatusCode2(statusCode)
                    }
                }
            }
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
    
    func studyAccept() {
        mainView.subtitleLabel.textColor = .gray7
        mainView.okButton.addTarget(self, action: #selector(acceptButtonClicked), for: .touchUpInside)
    }
    
    @objc func acceptButtonClicked() {
        let idToken = UserDefaultsHelper.standard.idToken
        apiService.acceptStudy(idToken: idToken, uid: uid) { [weak self] statusCode in
            self?.checkStatusCode3(statusCode)
        }
    }
    
    private func checkStatusCode3(_ statusCode: Int) {
        guard let pvc = self.presentingViewController else { return }
        switch statusCode {
        case 200:
            dismiss(animated: true) {
                let nextVC = ChatViewController()
                nextVC.viewModel.yourID = self.uid
                nextVC.viewModel.yourNickname = self.nickname
                pvc.navigationController?.pushViewController(nextVC, animated: true)
            }
            print("스터디 수락 성공🟢")
        case 201:
            dismiss(animated: true) {
                pvc.view.makeToast("상대방이 이미 다른 새싹과 스터디를 함께 하는 중입니다", duration: 1.0, position: .top)
            }
            print("상대방이 이미 다른 사용자와 매칭된 상태🟠")
        case 202:
            dismiss(animated: true) {
                pvc.view.makeToast("상대방이 스터디 찾기를 그만두었습니다", duration: 1.0, position: .top)
            }
            print("상대방이 새싹 찾기를 중단한 상태🟠")
        case 203:
            dismiss(animated: true) {
                pvc.view.makeToast("앗! 누군가가 나의 스터디를 수락하였어요!", duration: 1.0, position: .top)
            }
            print("내가 이미 다른 사용자와 매칭된 상태🟠")
        case 401:
            firebaseAuthManager.getIdToken { idToken in
                if let idToken {
                    self.apiService.acceptStudy(idToken: idToken, uid: self.uid) { statusCode in
                        self.checkStatusCode3(statusCode)
                    }
                }
            }
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
    
    func cancleStudy() {
        mainView.okButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                let idToken = UserDefaultsHelper.standard.idToken
                vc.apiService.cancleStudy(idToken: idToken, uid: vc.uid) { statusCode in
                    vc.checkStatusCode4(statusCode)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func checkStatusCode4(_ statusCode: Int) {
        switch statusCode {
        case 200:
            guard let pvc = self.presentingViewController else { return }
            dismiss(animated: true) {
                guard let viewControllerStack = pvc.navigationController?.viewControllers else { return }
                for viewController in viewControllerStack {
                    pvc.navigationController?.popToViewController(viewController, animated: true)
                }
            }
            print("스터디 취소 성공🟢")
        case 201:
            print("잘못된 otheruid🟠")
        case 401:
            firebaseAuthManager.getIdToken { idToken in
                if let idToken {
                    self.apiService.cancleStudy(idToken: idToken, uid: self.uid) { statusCode in
                        self.checkStatusCode4(statusCode)
                    }
                }
            }
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
