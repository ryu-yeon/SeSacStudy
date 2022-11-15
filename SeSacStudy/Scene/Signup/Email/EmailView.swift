//
//  EmailView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import UIKit

import SnapKit

final class EmailView: BaseView {
    
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
        view.text = "이메일을 입력해 주세요"
        view.textColor = .black
//        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 20)
        view.setLineHeight(lineHeight: 1.08)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let subTextLabel: UILabel = {
        let view = UILabel()
        view.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        view.textColor = .gray7
//        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 16)
        view.setLineHeight(lineHeight: 1.08)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let emailTextField: BaseTextField = {
        let view = BaseTextField()
        view.textField.placeholder = "SeSAC@email.com"
        view.textField.keyboardType = .emailAddress
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
        
        [labelView, emailTextField, nextButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        self.addSubview(stackView)
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
        
        emailTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(22)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}

