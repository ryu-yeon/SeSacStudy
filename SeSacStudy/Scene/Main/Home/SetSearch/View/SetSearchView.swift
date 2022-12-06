//
//  SetSearchView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/17.
//

import UIKit

import SnapKit

final class SetSearchView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = .clear
        
        view.register(StudyCollectionViewCell.self, forCellWithReuseIdentifier: StudyCollectionViewCell.reusableIdentifier)
        view.register(
            BaseCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BaseCollectionHeaderView.reusseIdentifier)
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
    
    fileprivate func configureLayout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(100),
            heightDimension: .absolute(32)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: .fixed(8), bottom: .fixed(8))
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: itemSize.heightDimension
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        group.edgeSpacing = NSCollectionLayoutEdgeSpacing(leading: nil, top: nil, trailing: nil, bottom: .fixed(8))
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 24, trailing: 0)
        
        // Header
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(18))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
        
    }
    
    func updateSearchButton(keyboardVisibleHeight: CGFloat) {
        if keyboardVisibleHeight == 0 {
            searchButton.layer.cornerRadius = 8
            searchButton.snp.updateConstraints { make in
                make.horizontalEdges.equalToSuperview().inset(16)
                make.bottom.equalToSuperview().inset(50)
            }
        } else {
            let totalHeight = keyboardVisibleHeight
            searchButton.layer.cornerRadius = 0
            searchButton.snp.updateConstraints { make in
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview().inset(totalHeight)
            }
        }
    }
}
