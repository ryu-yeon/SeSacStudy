//
//  ShopViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import UIKit

import RxCocoa
import RxSwift
import Tabman
import Pageboy
import Toast

final class ShopViewController: BaseViewController {
    
    let mainView = ShopView()
    let viewModel = ShopViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setContainerView()
        setProfile()
        setSaveButton()
    }
    
    override func setNavigationBar() {
        navigationItem.title = "새싹샵"
    }
    
    private func setProfile() {
        
        mainView.backgroundImageView.image = UIImage(named: BackgroundImage(rawValue: viewModel.user?.background ?? 0)!.image)
        mainView.profileImagView.image = UIImage(named: SesacImage(rawValue: viewModel.user?.sesac ?? 0)!.image)

    }
    
    private func setSaveButton() {
        mainView.saveButton.rx.tap
            .bind { [self] _ in
                viewModel.vaild
                    .bind { [self] value in
                        if value {
                            mainView.makeToast(ShopItemStatusCode.Success.message, duration: 1.0, position: .top)
                        } else {
                            mainView.makeToast(ShopItemStatusCode.NotHaveItem.message, duration: 1.0, position: .top)
                        }
                    }
                    .disposed(by: disposeBag)
            }
            .disposed(by: disposeBag)

    }
    
    private func setContainerView() {
        let vc = ShopTabViewController()
        
        self.addChild(vc)
        mainView.containerView.addSubview(vc.view)
        vc.view.frame = mainView.containerView.bounds
        vc.didMove(toParent: self)
        
        vc.firstVC.sesacDelegate = self
        vc.secondVC.backgroundDelegate = self
    }
}

extension ShopViewController: SesacTabDelegate {
    func getSesacNumber(index: Int) {
        mainView.profileImagView.image = UIImage(named: SesacImage(rawValue: index)!.image)
        viewModel.selectSesac = index
    }
}

extension ShopViewController: BackgroundTabDelegate {
    func getBackgroundNumber(index: Int) {
        mainView.backgroundImageView.image = UIImage(named: BackgroundImage(rawValue: index)!.image)
        viewModel.selectBackground = index
    }
}

