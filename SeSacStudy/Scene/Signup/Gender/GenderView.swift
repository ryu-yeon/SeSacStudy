//
//  GenderView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import UIKit

import SnapKit

final class GenderView: BaseView {
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .top
        return view
    }()
    
    let labelView = UIView()
    
    let textLabel: UILabel = {
        let view = UILabel()
        view.text = "성별을 선택해 주세요"
        view.textColor = .black
        view.font = .display1_R20
        view.setLineHeight(lineHeight: 1.08)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let subTextLabel: UILabel = {
        let view = UILabel()
        view.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        view.textColor = .gray7
        view.font = .title2_R16
        view.setLineHeight(lineHeight: 1.08)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let manButton: UIButton = {
        let view = UIButton()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray3.cgColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.tintColor = .black
        return view
    }()
    
    let manImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "man")
        return view
    }()
    
    let manLabel: UILabel = {
        let view = UILabel()
        view.text = "남자"
        view.textColor = .black
        view.font = .title2_R16
        return view
    }()
    
    let womanButton: UIButton = {
        let view = UIButton()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray3.cgColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.tintColor = .black
        return view
    }()
    
    let womanImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "woman")
        return view
    }()
    
    let womanLabel: UILabel = {
        let view = UILabel()
        view.text = "여자"
        view.textColor = .black
        view.font = .title2_R16
        return view
    }()
    
    let nextButton: BaseButton = {
        let view = BaseButton()
        view.setTitle("다음", for: .normal)
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .systemBackground
        
        [textLabel, subTextLabel].forEach {
            labelView.addSubview($0)
        }
        
        [labelView, manButton, nextButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [stackView, womanButton, manImageView, manLabel, womanImageView, womanLabel].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide).inset(UIScreen.main.bounds.height * 0.1)
            make.bottom.equalTo(self).inset(UIScreen.main.bounds.height * 0.42)
        }
        
        labelView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(66)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(32)
        }
        
        subTextLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(26)
        }
        
        manButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalTo(self.snp.centerX).offset(-6)
            make.height.equalTo(120)
        }
        
        manImageView.snp.makeConstraints { make in
            make.top.equalTo(manButton).inset(14)
            make.centerX.equalTo(manButton)
            make.size.equalTo(64)
        }

        manLabel.snp.makeConstraints { make in
            make.bottom.equalTo(manButton).inset(14)
            make.centerX.equalTo(manButton)
            make.width.equalTo(30)
            make.height.equalTo(26)
        }
        
        womanButton.snp.makeConstraints { make in
            make.centerY.equalTo(manButton.snp.centerY)
            make.leading.equalTo(self.snp.centerX).offset(6)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(110)
        }
        
        womanImageView.snp.makeConstraints { make in
            make.top.equalTo(womanButton).inset(14)
            make.centerX.equalTo(womanButton)
            make.size.equalTo(64)
        }
        
        womanLabel.snp.makeConstraints { make in
            make.bottom.equalTo(womanButton).inset(14)
            make.centerX.equalTo(womanButton)
            make.width.equalTo(30)
            make.height.equalTo(26)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}

