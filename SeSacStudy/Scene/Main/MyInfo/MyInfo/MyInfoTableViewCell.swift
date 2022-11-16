//
//  MyInfoTableViewCell.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/12.
//

import UIKit

import SnapKit

final class MyInfoTableViewCell: BaseTableViewCell {
    
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.isHidden = true
        return view
    }()
    
    let iconImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
//        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 16)
        return view
    }()
    
    let arrowImagView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "more_arrow")
        view.tintColor = .gray7
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    override func configureUI() {
        contentView.backgroundColor = .clear
        [profileImageView, iconImageView, titleLabel, arrowImagView].forEach {
            contentView.addSubview($0)
        }
        self.selectionStyle = .none
    }
    
    override func setConstraints() {
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self)
            make.width.height.equalTo(24)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(iconImageView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.height.equalTo(26)
        }
        
        arrowImagView.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self)
            make.width.height.equalTo(24)
        }
    }
}
