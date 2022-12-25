//
//  BackgroundShopTabView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/25.
//

import UIKit

import SnapKit

final class BackgroundShopTabView: BaseView {
    lazy var collecionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        view.register(BackgroundCollectionViewCell.self, forCellWithReuseIdentifier: BackgroundCollectionViewCell.reusableIdentifier)
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .clear
        self.addSubview(collecionView)
    }
    
    override func setConstraints() {
        collecionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
    
    private func configureLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(165)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: itemSize.heightDimension
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: .fixed(16))
        
        let section = NSCollectionLayoutSection(group: group)

        return UICollectionViewCompositionalLayout(section: section)
    }
}
