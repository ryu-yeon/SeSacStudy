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
    let viewModel = BirthViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setDatePicker()
        setDateLabels()
        setNextButton()
        
        viewModel.fetch()
    }
    
    private func setDatePicker() {
        mainView.datePicker.date = viewModel.profile?.birth ?? Date()
        
        mainView.datePicker.rx.date
            .withUnretained(self)
            .bind { (vc, value) in
                vc.viewModel.isVaildDate(date: value)
            }
            .disposed(by: disposeBag)
    }
    
    private func setDateLabels() {
        viewModel.date
            .withUnretained(self)
            .bind { (vc, value) in
                vc.viewModel.profile?.birth = value
                vc.viewModel.dateformat(date: value)
                vc.mainView.yearView.dateLabel.text = vc.viewModel.year
                vc.mainView.mounthView.dateLabel.text = vc.viewModel.mouth
                vc.mainView.dayView.dateLabel.text = vc.viewModel.day
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
                    let nextVC = EmailViewController()
                    nextVC.viewModel.profile = vc.viewModel.profile
                    vc.navigationController?.pushViewController(nextVC, animated: true)
                } else {
                    vc.mainView.makeToast("새싹스터디는 만 17세 이상만 사용할 수 있습니다.", duration: 1.0, position: .top)
                }
            }
            .disposed(by: disposeBag)
    }
}
