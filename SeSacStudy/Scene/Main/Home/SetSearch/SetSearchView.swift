//
//  SetSearchView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/17.
//

import UIKit

import SnapKit

final class SetSearchView: BaseView {
    
    let collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
//        layout.sectionInset = .zero
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .brown
        return view
    }()
        
    
    let searchButton: BaseButton = {
        let view = BaseButton()
        view.setTitle("새싹 찾기", for: .normal)
        view.backgroundColor = .brandGreen
        return view
    }()

    override func configureUI() {
        
        self.backgroundColor = .systemBackground
        [collectionView, searchButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
        
        searchButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(48)
        }
    }
}
