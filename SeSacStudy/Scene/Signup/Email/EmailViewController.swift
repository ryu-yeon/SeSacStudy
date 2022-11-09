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
    private let viewModel = EmailViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        mainView.emailTextField.becomeFirstResponder()
        
        mainView.emailTextField.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { vc, value in
                vc.mainView.lineView.backgroundColor = value != "" ? .black : .gray3
                vc.viewModel.isVaildEmail(email: value)
            }
            .disposed(by: disposeBag)
        
        
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
                    vc.navigationController?.pushViewController(nextVC, animated: true)
                } else {
                    vc.mainView.makeToast("이메일 형식이 올바르지 않습니다.", duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
     
        viewModel.fetch()
    }
}
