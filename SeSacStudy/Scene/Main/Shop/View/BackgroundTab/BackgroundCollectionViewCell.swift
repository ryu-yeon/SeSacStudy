//
//  BackgroundCollectionViewCell.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/25.
//

import UIKit

import SnapKit

final class BackgroundCollectionViewCell: BaseCollectionViewCell {
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .title2_R16
        return view
    }()
    
    let detailLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.numberOfLines = 0
        view.font = .body3_R14
        view.setLineHeight(lineHeight: 170)
        return view
    }()
    
    let buyButton: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 30
        view.titleLabel?.font = .title5_M12
        return view
    }()
    
    override func configureUI() {
        contentView.backgroundColor = .clear
        [backgroundImageView, titleLabel, detailLabel, buyButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        backgroundImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview()
            make.size.equalTo(165)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(43.5)
            make.leading.equalTo(backgroundImageView.snp.trailing).offset(12)
            make.trailing.equalTo(buyButton.snp.leading)
            make.height.equalTo(22)
        }
        
        buyButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview()
            make.width.equalTo(52)
            make.height.equalTo(20)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(backgroundImageView.snp.trailing).offset(12)
            make.trailing.equalToSuperview()
            make.height.greaterThanOrEqualTo(50)
        }
    }
    
}
