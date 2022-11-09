//
//  OnboardingViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/07.
//

import UIKit

import RxCocoa
import RxSwift

final class OnboardingViewController: BaseViewController {
    
    private let mainView = OnboardingView()
    private let viewModel = OnboardingViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: OnboardingCollectionViewCell.reusableIdentifier)
        
        viewModel.list
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: OnboardingCollectionViewCell.reusableIdentifier, cellType: OnboardingCollectionViewCell.self)) { (item, element, cell) in
                cell.textLabel.setRangeTextColor(text: element.text, length: element.range, color: .brandGreen)
                cell.onboardingImage.image = UIImage(named: element.image)
            }
            .disposed(by: disposeBag)
        
        mainView.pageControl.numberOfPages = viewModel.data.count
        
        mainView.startButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                UserDefaults.standard.set(true, forKey: "start")
                
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                let sceneDelegate = windowScene?.delegate as? SceneDelegate
                let nextVC = UINavigationController(rootViewController: LoginViewController())
                sceneDelegate?.window?.rootViewController = nextVC
                sceneDelegate?.window?.makeKeyAndVisible()
            }
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.willEndDragging
            .bind { (velocity, targetContentOffset) in
                let page = Int(targetContentOffset.pointee.x / self.mainView.frame.width)
                self.mainView.pageControl.currentPage = page
            }
            .disposed(by: disposeBag)
        
        mainView.pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
        
        viewModel.fetch()
    }
    
    @objc func pageChanged() {

        let index = IndexPath(item: mainView.pageControl.currentPage, section: 0)
        let rect = mainView.collectionView.layoutAttributesForItem(at: index)?.frame
        mainView.collectionView.scrollRectToVisible(rect!, animated: true)
    }
}
