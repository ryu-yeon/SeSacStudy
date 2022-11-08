//
//  LoginView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/08.
//

import UIKit

import SnapKit

final class LoginView: BaseView {
    
    let textLabel: UILabel = {
        let view = UILabel()
        view.text = "새싹 서비스 이용을 위해\n휴대폰 번호를 입력해 주세요"
        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 20)
        view.setLineHeight(lineHeight: 1.08)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let numberTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "휴대폰 번호(-없이 숫자만 입력)"
        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 14)
        view.borderStyle = .none
        view.keyboardType = .phonePad
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray6
        return view
    }()

    let checkButton: UIButton = {
        let view = UIButton()
        view.setTitle("인증 문자 받기", for: .normal)
        view.titleLabel?.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 14)
        view.backgroundColor = .gray6
        view.tintColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .systemBackground
        [textLabel, numberTextField, lineView, checkButton].forEach {
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
            make.leading.trailing.equalTo(self).inset(28)
            make.height.equalTo(22)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(numberTextField.snp.bottom).offset(12)
            make.leading.trailing.equalTo(self).inset(16)
            make.height.equalTo(1)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(72)
            make.leading.trailing.equalTo(self).inset(16)
            make.height.equalTo(48)
        }
    }
}
