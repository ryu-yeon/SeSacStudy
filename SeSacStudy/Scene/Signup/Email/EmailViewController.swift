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
        setTextField()
        setNextButton()
        
        viewModel.fetch()
    }
    
    private func setTextField() {
        mainView.emailTextField.textField.becomeFirstResponder()
        
        mainView.emailTextField.textField.text = viewModel.profile?.email
        
        mainView.emailTextField.textField.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { vc, value in
                vc.mainView.emailTextField.lineView.backgroundColor = value != "" ? .black : .gray3
                vc.viewModel.isVaildEmail(email: value)
                vc.viewModel.profile?.email = value
            }
            .disposed(by: disposeBag)
    }
    
    private func setNextButton() {
        viewModel.vaild
            .withUnretained(self)
            .bind { (vc, value) in
                vc.mainView.nextButton.backgroundColor = value ? .brandGreen : .gray6
            }
            .disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                if vc.viewModel.isVaild {
                    let nextVC = GenderViewController()
                    nextVC.viewModel.profile = vc.viewModel.profile
                    vc.navigationController?.pushViewController(nextVC, animated: true)
                } else {
                    vc.mainView.makeToast("이메일 형식이 올바르지 않습니다.", duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
    }
}
