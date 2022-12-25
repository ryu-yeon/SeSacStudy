//
//  ShopView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import UIKit

import SnapKit

final class ShopView: BaseView {
    
    let backgroundImageView: UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let profileImagView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .clear
        return view
    }()
    
    let saveButton: UIButton = {
        let view = BaseButton()
        view.backgroundColor = .brandGreen
        view.setTitle("저장하기", for: .normal)
        return view
    }()

    let containerView = UIView()
    
    override func configureUI() {
        self.backgroundColor = .systemBackground
        
        [backgroundImageView, profileImagView, saveButton, containerView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(15)
            make.horizontalEdges.equalToSuperview().inset(14)
            make.height.equalTo(175)
        }
        
        profileImagView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(backgroundImageView.snp.top).offset(10)
            make.size.equalTo(184)
        }
        
        saveButton.snp.makeConstraints { make in
            make.top.trailing.equalTo(backgroundImageView).inset(12)
            make.width.equalTo(80)
            make.height.equalTo(40)
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
