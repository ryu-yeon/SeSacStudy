//
//  OnboardingCollectionViewCell.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/08.
//

import UIKit

import SnapKit

final class OnboardingCollectionViewCell: BaseCollectionViewCell {
    
    let textLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.numberOfLines = 0
        view.font = UIFont(name: Font.NotoSansMedium.rawValue, size: 24)
        return view
    }()
    
    let onboardingImage: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        return view
    }()
    
    override func configureUI() {
        contentView.backgroundColor = .clear
        [textLabel, onboardingImage].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        textLabel.snp.makeConstraints { make in
            make.bottom.equalTo(onboardingImage.snp.top).offset(-56)
            make.leading.trailing.equalTo(self).inset(40)
            make.height.equalTo(76)
        }
        
        onboardingImage.snp.makeConstraints { make in
            make.bottom.equalTo(self).offset(-10)
            make.leading.trailing.equalTo(self).inset(8)
            make.height.equalTo(onboardingImage.snp.width)
        }
    }    
}
