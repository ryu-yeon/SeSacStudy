//
//  LoginCheckView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/08.
//

import UIKit

import SnapKit

final class LoginCheckView: BaseView {
    let textLabel: UILabel = {
        let view = UILabel()
        view.text = "인증문자가 문자로 전송되었어요"
        view.textColor = .black
        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 20)
        view.setLineHeight(lineHeight: 1.08)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let numberTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "인증번호 입력"
        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 14)
        view.borderStyle = .none
        view.keyboardType = .phonePad
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    
    let timerLabel: UILabel = {
        let view = UILabel()
        view.text = "60"
        view.font = UIFont(name: Font.NotoSansMedium.rawValue, size: 14)
        view.textAlignment = .right
        view.textColor = .brandGreen
        return view
    }()
    
    let resendButton: UIButton = {
        let view = UIButton()
        view.setTitle("재전송", for: .normal)
        view.titleLabel?.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 14)
        view.backgroundColor = .brandGreen
        view.layer.cornerRadius = 8
        return view
    }()
    
    let checkButton: UIButton = {
        let view = UIButton()
        view.setTitle("인증하고 시작하기", for: .normal)
        view.titleLabel?.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 14)
        view.backgroundColor = .gray6
        view.tintColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .systemBackground
        [textLabel, numberTextField, lineView, timerLabel, resendButton, checkButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(81)
            make.leading.trailing.equalTo(self).inset(74)
            make.height.equalTo(64)
        }
        
        numberTextField.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(77)
            make.leading.equalTo(self).inset(28)
            make.trailing.equalTo(timerLabel.snp.leading).offset(-8)
            make.height.equalTo(22)
        }
        
        timerLabel.snp.makeConstraints { make in
            make.centerY.equalTo(numberTextField.snp.centerY)
            make.trailing.equalTo(resendButton.snp.leading).offset(-20)
            make.width.equalTo(37)
            make.height.equalTo(22)
        }
        
        resendButton.snp.makeConstraints { make in
            make.centerY.equalTo(numberTextField.snp.centerY)
            make.trailing.equalTo(self).offset(-16)
            make.width.equalTo(72)
            make.height.equalTo(40)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(numberTextField.snp.bottom).offset(12)
            make.leading.equalTo(self).inset(16)
            make.trailing.equalTo(resendButton.snp.leading).offset(-8)
            make.height.equalTo(1)
        }
        
        checkButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(16)
            make.height.equalTo(48)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(UserDefaults.standard.float(forKey: "bottom"))
        }
    }
}
