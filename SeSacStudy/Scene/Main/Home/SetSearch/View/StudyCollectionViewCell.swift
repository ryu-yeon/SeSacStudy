//
//  StudyCollectionViewCell.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/21.
//

import UIKit

import SnapKit

final class StudyCollectionViewCell: BaseCollectionViewCell {
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = .black
        view.font = .title4_R14
        view.setLineHeight(lineHeight: 1.15)
        return view
    }()
    
    let xImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "xmark")
        view.tintColor = .brandGreen
        view.contentMode = .scaleAspectFit
        view.isHidden = true
        return view
    }()
    
    override func configureUI() {
        contentView.backgroundColor = .white
        [titleLabel, xImageView].forEach {
            contentView.addSubview($0)
        }
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray4.cgColor
        contentView.layer.cornerRadius = 8
    }
    
    override func setConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(36)
            make.verticalEdges.equalToSuperview().inset(5)
        }
        
        xImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    func update() {
        titleLabel.snp.updateConstraints { make in
            make.trailing.equalToSuperview().inset(16)
        }
    }
}
