//
//  SesacCollectionViewCell.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/24.
//

import UIKit

import SnapKit

final class SesacCollectionViewCell: BaseCollectionViewCell {
    
    let sesacImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.gray2.cgColor
        view.layer.borderWidth = 1
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
        [sesacImageView, titleLabel, detailLabel, buyButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        sesacImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(165)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(sesacImageView.snp.bottom).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalTo(buyButton.snp.leading)
            make.height.equalTo(26)
        }
        
        buyButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(9)
            make.width.equalTo(52)
            make.height.equalTo(20)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
}
