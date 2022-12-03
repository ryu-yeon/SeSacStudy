//
//  LoginCheckView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/08.
//

import UIKit

import SnapKit

final class LoginCheckView: BaseView {
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .top
        return view
    }()
    
    let textLabel: UILabel = {
        let view = UILabel()
        view.text = "인증문자가 문자로 전송되었어요"
        view.textColor = .black
        view.font = .display1_R20
        view.setLineHeight(lineHeight: 1.08)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let numberTextField: BaseTextField = {
        let view = BaseTextField()
        view.textField.placeholder = "인증번호 입력"
        view.textField.keyboardType = .phonePad
        return view
    }()
    
    let timerLabel: UILabel = {
        let view = UILabel()
        view.text = "60"
        view.font = .title3_M14
        view.textAlignment = .right
        view.textColor = .brandGreen
        return view
    }()
    
    let resendButton: BaseButton = {
        let view = BaseButton()
        view.setTitle("재전송", for: .normal)
        view.backgroundColor = .brandGreen
        return view
    }()
    
    let checkButton: BaseButton = {
        let view = BaseButton()
        view.setTitle("인증하고 시작하기", for: .normal)
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .systemBackground
        [textLabel, numberTextField, checkButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [stackView, timerLabel, resendButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide).inset(UIScreen.main.bounds.height * 0.07)
            make.bottom.equalTo(self).inset(UIScreen.main.bounds.height * 0.45)
        }
        
        textLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(32)
        }
        
        numberTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(96)
            make.height.equalTo(48)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(numberTextField.snp.centerY)
            make.trailing.equalTo(numberTextField).inset(12)
            make.width.equalTo(37)
            make.height.equalTo(22)
        }
        
        resendButton.snp.makeConstraints { make in
            make.centerY.equalTo(numberTextField.snp.centerY)
            make.trailing.equalToSuperview().offset(-16)
            make.width.equalTo(72)
            make.height.equalTo(40)
        }
        
        checkButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
