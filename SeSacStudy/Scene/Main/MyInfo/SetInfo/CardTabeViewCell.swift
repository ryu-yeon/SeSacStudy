//
//  CardTabeViewCell.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/14.
//

import UIKit

import SnapKit

final class CardTableViewCell: BaseTableViewCell {
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.backgroundColor = .clear
        return view
    }()
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        return view
    }()
    
    let infoView: InfoView = {
        let view = InfoView()
        view.layer.borderColor = UIColor.gray2.cgColor
        view.layer.borderWidth = 1
        view.layer.cornerRadius = 8
        return view
    }()
    
    override func configureUI() {
        contentView.backgroundColor = .clear
        [backgroundImageView, profileImageView, infoView].forEach {
            contentView.addSubview($0)
            self.selectionStyle = .none
        }
    }
    
    override func setConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(194)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(backgroundImageView.snp.centerX)
            make.centerY.equalTo(backgroundImageView.snp.centerY).offset(19)
            make.size.equalTo(184)
        }
        
        infoView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
