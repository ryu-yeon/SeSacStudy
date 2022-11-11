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
    private let viewModel = NicknameViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        mainView.nicknameTextField.becomeFirstResponder()
        
        mainView.nicknameTextField.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { vc, value in
                vc.mainView.lineView.backgroundColor = value != "" ? .black : .gray3
                vc.viewModel.isVaildNickname(nickname: value)
            }
            .disposed(by: disposeBag)
        
        
        viewModel.vaild
            .bind { value in
                self.mainView.nextButton.backgroundColor = value ? .brandGreen : .gray6
            }
            .disposed(by: disposeBag)
        
        mainView.nextButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                
                if vc.viewModel.isVaild {
                    let nextVC = BirthViewController()
                    vc.navigationController?.pushViewController(nextVC, animated: true)
                } else {
                    vc.mainView.makeToast("닉네임은 1자 이상 10자 이내로 부탁드려요.", duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
     
        viewModel.fetch()
    }
}