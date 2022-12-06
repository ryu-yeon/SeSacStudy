//
//  EmailViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class EmailViewController: BaseViewController {
    
    private let mainView = EmailView()
    let viewModel = EmailViewModel()
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
        mainView.emailTextField.textField.becomeFirstResponder()
        
        mainView.emailTextField.textField.text = viewModel.profile?.email
        
        mainView.emailTextField.textField.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { vc, value in
                vc.mainView.emailTextField.setLine()
                vc.viewModel.isVaildEmail(email: value)
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
                    let nextVC = GenderViewController()
                    nextVC.viewModel.profile = vc.viewModel.profile
                    vc.navigationController?.pushViewController(nextVC, animated: true)
                } else {
                    vc.mainView.makeToast(InVaild.Email.message, duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
    }
}
