//
//  OnboardingView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/07.
//

import UIKit

import SnapKit

final class OnboardingView: BaseView {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        
        layout.itemSize = CGSize(width: width, height: 610)
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isPagingEnabled = true
        view.decelerationRate = .fast
        return view
    }()
    
    let pageControl: UIPageControl = {
        let view = UIPageControl()
        view.pageIndicatorTintColor = .lightGray
        view.currentPageIndicatorTintColor = .black
        return view
    }()
    
    let startButton: UIButton = {
        let view = UIButton()
        view.setTitle("시작하기", for: .normal)
        view.titleLabel?.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 14)
        view.tintColor = .white
        view.layer.cornerRadius = 8
        view.backgroundColor = .brandGreen
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .systemBackground
        [collectionView, pageControl, startButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(self)
            make.bottom.equalTo(pageControl.snp.top).offset(-56)
        }
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalTo(self)
            make.leading.trailing.equalTo(self).inset(40)
            make.height.equalTo(20)
            make.bottom.equalTo(startButton.snp.top).offset(-42)
        }
        
        startButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }
}
