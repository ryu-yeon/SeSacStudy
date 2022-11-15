//
//  LoginView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/08.
//

import UIKit

import SnapKit

final class LoginView: BaseView {
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .top
        return view
    }()
    
    let textLabel: UILabel = {
        let view = UILabel()
        view.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        view.textColor = .black
        view.font = .display1_R20
        view.setLineHeight(lineHeight: 1.08)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let numberTextField: BaseTextField = {
        let view = BaseTextField()
        view.textField.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        view.textField.keyboardType = .phonePad
        return view
    }()

    let checkButton: BaseButton = {
        let view = BaseButton()
        view.setTitle("인증 문자 받기", for: .normal)
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .systemBackground
        [textLabel, numberTextField, checkButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        self.addSubview(stackView)
    }
    
    override func setConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide).inset(UIScreen.main.bounds.height * 0.1)
            make.bottom.equalToSuperview().inset(UIScreen.main.bounds.height * 0.42)
        }
        
        textLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(64)
        }
        
        numberTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(self).inset(16)
            make.height.equalTo(48)
        }
        
        checkButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
