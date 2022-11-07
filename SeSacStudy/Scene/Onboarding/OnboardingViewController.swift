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
        
        mainView.collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        
        viewModel.list
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: "OnboardingCollectionViewCell", cellType: OnboardingCollectionViewCell.self)) { (item, element, cell) in
                cell.textLabel.text = element.text
                cell.onboardingImage.image = UIImage(named: element.image)
            }
            .disposed(by: disposeBag)
        
        mainView.pageControl.numberOfPages = viewModel.data.count
        
        mainView.startButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                
            }
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.willEndDragging
            .bind { (velocity, targetContentOffset) in
                let page = Int(targetContentOffset.pointee.x / self.mainView.frame.width)
                self.mainView.pageControl.currentPage = page
            }
            .disposed(by: disposeBag)
        
        mainView.collectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        mainView.pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged)
        
        viewModel.fetch()
    }
    
    @objc func pageChanged() {

        let indexPath = IndexPath(item: mainView.pageControl.currentPage, section: 0)
        mainView.collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        print(mainView.pageControl.currentPage)
    }
}

extension OnboardingViewController: UICollectionViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let x = scrollView.contentOffset.x + (width/2)

        let newPage = Int(x/width)
        if mainView.pageControl.currentPage != newPage {
            mainView.pageControl.currentPage = newPage
        }
        print(mainView.pageControl.currentPage)
    }
}