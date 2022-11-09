//
//  BirthViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/09.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class BirthViewController: BaseViewController {
    
    private let mainView = BirthView()
    private let viewModel = BirthViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        
        mainView.datePicker.rx.date
            .withUnretained(self)
            .bind { (vc, value) in
                vc.viewModel.isVaildDate(date: value)
            }
            .disposed(by: disposeBag)
        
        viewModel.date
            .withUnretained(self)
            .bind { (vc, value) in
                vc.viewModel.dateformat(date: value)
                vc.mainView.yearView.dateLabel.text = vc.viewModel.year
                vc.mainView.mounthView.dateLabel.text = vc.viewModel.mouth
                vc.mainView.dayView.dateLabel.text = vc.viewModel.day
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
                    let nextVC = EmailViewController()
                    vc.navigationController?.pushViewController(nextVC, animated: true)
                } else {
                    vc.mainView.makeToast("새싹스터디는 만 17세 이상만 사용할 수 있습니다.", duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.fetch()
    }
    
}

