//
//  NicknameViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/09.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class NicknameViewController: BaseViewController {
    
    private let mainView = NicknameView()
    let viewModel = NicknameViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setBackButton()
        setTextField()
        setNextButton()
    }
    
    private func setTextField() {
        mainView.nicknameTextField.textField.becomeFirstResponder()
        
        mainView.nicknameTextField.textField.text = viewModel.profile?.nickname
        
        mainView.nicknameTextField.textField.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { vc, value in
                vc.mainView.nicknameTextField.setLine()
                vc.viewModel.isVaildNickname(nickname: value)
            }
            .disposed(by: disposeBag)
    }
    
    private func setNextButton() {
        viewModel.vaild
            .asDriver(onErrorJustReturn: false)
            .map { $0 ? .brandGreen : .gray6 }
            .drive(mainView.nextButton.rx.backgroundColor)
            .disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                if vc.viewModel.vaild.value {
                    let nextVC = BirthViewController()
                    nextVC.viewModel.profile = vc.viewModel.profile
                    vc.navigationController?.pushViewController(nextVC, animated: true)
                } else {
                    vc.mainView.makeToast(InVaild.Nickname.message, duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
    }
}
