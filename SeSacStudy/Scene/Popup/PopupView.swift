//
//  PopupView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/15.
//

import UIKit

import SnapKit

final class PopupView: BaseView {
    
    let popupContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .black
        view.font = .body1_M16
        return view
    }()
    
    let subtitleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .black
        view.font = .title4_R14
        return view
    }()
    
    let cancleButton: BaseButton = {
        let view = BaseButton()
        view.setTitleColor(.black, for: .normal)
        view.setTitle("취소", for: .normal)
        view.backgroundColor = .gray2
        return view
    }()
    
    let okButton: BaseButton = {
        let view = BaseButton()
        view.setTitle("확인", for: .normal)
        view.backgroundColor = .brandGreen
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        [popupContainer, titleLabel, subtitleLabel, cancleButton, okButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        popupContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(156)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(popupContainer)
            make.top.equalTo(popupContainer).inset(16)
            make.horizontalEdges.equalTo(popupContainer).inset(16.5)
            make.height.equalTo(30)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(popupContainer)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(popupContainer).inset(16.5)
            make.height.equalTo(22)
        }
        
        cancleButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            make.leading.equalTo(popupContainer).inset(16)
            make.trailing.equalTo(popupContainer.snp.centerX).offset(-4)
            make.height.equalTo(48)
        }
        
        okButton.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(16)
            make.trailing.equalTo(popupContainer).inset(16)
            make.leading.equalTo(popupContainer.snp.centerX).offset(4)
            make.height.equalTo(48)
        }
    }
}
