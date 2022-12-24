//
//  SearchView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/17.
//

import UIKit

import SnapKit

final class SearchView: BaseView {
    
    let nearButton: UIButton = {
        let view = UIButton()
        view.setTitle("주변 새싹", for: .normal)
        view.titleLabel?.font = .title3_M14
        view.setTitleColor(.brandGreen, for: .normal)
        var lineView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 1))
        lineView.backgroundColor = UIColor.brandGreen
        view.addSubview(lineView)
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandGreen
        return view
    }()
    
    let recieveButton: UIButton = {
        let view = UIButton()
        view.setTitle("받은 요청", for: .normal)
        view.titleLabel?.font = .title3_M14
        view.setTitleColor(.gray6, for: .normal)
        var lineView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 1))
        lineView.backgroundColor = UIColor.gray6
        view.addSubview(lineView)
        return view
    }()
    
    let lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = .gray6
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height - 45
        
        layout.itemSize = CGSize(width: width, height: height)
        layout.scrollDirection = .horizontal
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isPagingEnabled = true
        view.decelerationRate = .fast
        
        view.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reusableIdentifier)
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .systemBackground
        
        nearButton.addSubview(lineView)
        recieveButton.addSubview(lineView2)
        
        [nearButton, recieveButton, collectionView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        nearButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalTo(self.snp.centerX)
            make.height.equalTo(44)
        }
        
        lineView.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        recieveButton.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.trailing.equalToSuperview()
            make.leading.equalTo(self.snp.centerX)
            make.height.equalTo(44)
        }
        
        lineView2.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(nearButton.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
