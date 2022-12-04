//
//  TitleColleciontViewCell.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/16.
//

import UIKit

import SnapKit

final class TitleCollectionViewCell: BaseCollectionViewCell {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .title4_R14
        view.textAlignment = .center
        return view
    }()
    
    override func configureUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray4.cgColor
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview().inset(5)
        }
    }
}
