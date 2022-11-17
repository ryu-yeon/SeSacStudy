//
//  InfoView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/14.
//

import UIKit

import SnapKit

class InfoView: BaseView {
    
    let nicknameLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .title1_M16
        return view
    }()
    
    let moreButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "more"), for: .normal)
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "새싹 타이틀"
        view.textColor = .black
        view.font = .title6_R12
        view.isHidden = true
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = Int(UIScreen.main.bounds.width) - 56 - Int(spacing) * 3
        
        layout.itemSize = CGSize(width: width / 2, height: 32)
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isHidden = true
        view.isScrollEnabled = false
        return view
    }()

    let reviewLabel: UILabel = {
        let view = UILabel()
        view.text = "새싹 리뷰"
        view.textColor = .black
        view.font = .title6_R12
        view.isHidden = true
        return view
    }()
    
    let reviewTextLabel: UILabel = {
        let view = UILabel()
        view.text = "첫 리뷰를 기다리는 중이에요!"
        view.numberOfLines = 0
        view.textColor = .gray6
        view.font = .body3_R14
        view.setLineHeight(lineHeight: 1.15)
        view.isHidden = true
        return view
    }()
    
    var list = [Int](repeating: 8, count: 0)
    
    override func configureUI() {
        self.backgroundColor = .clear
        [nicknameLabel, moreButton, titleLabel, collectionView, reviewLabel, reviewTextLabel].forEach {
            self.addSubview($0)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.reusableIdentifier)
    }
    
    func getData() {
        collectionView.reloadData()
    }
    
    override func setConstraints() {
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(40)
            make.height.equalTo(26)
        }
        
        moreButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(8)
            make.height.equalTo(128)
        }
        
        reviewLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(26)
        }
        
        reviewTextLabel.snp.makeConstraints { make in
            make.top.equalTo(reviewLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

extension InfoView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let title = ["좋은 매너", "정확한 시간 약속", "빠른 응답", "친절한 성격", "능숙한 실력", "유익한 시간"]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.reusableIdentifier, for: indexPath) as! TitleCollectionViewCell
        cell.titleLabel.text = title[indexPath.row]
        
        if list[indexPath.row] != 0 {
            cell.contentView.backgroundColor = .brandGreen
            cell.contentView.layer.borderWidth = 0
            cell.titleLabel.textColor = .white
        } else {
            cell.contentView.backgroundColor = .white
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = UIColor.gray4.cgColor
        }
        
        return cell
    }
}
