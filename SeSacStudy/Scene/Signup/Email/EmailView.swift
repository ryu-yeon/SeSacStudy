//
//  EmailView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import UIKit

import SnapKit

final class EmailView: BaseView {
    
    let textLabel: UILabel = {
        let view = UILabel()
        view.text = "이메일을 입력해 주세요"
        view.textColor = .black
        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 20)
        view.setLineHeight(lineHeight: 1.08)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let subTextLabel: UILabel = {
        let view = UILabel()
        view.text = "휴대폰 번호 변경 시 인증을 위해 사용해요"
        view.textColor = .gray7
        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 16)
        view.setLineHeight(lineHeight: 1.08)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let emailTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "SeSAC@email.com"
        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 14)
        view.borderStyle = .none
        view.keyboardType = .emailAddress
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray3
        return view
    }()
    
    let nextButton: UIButton = {
        let view = UIButton()
        view.setTitle("다음", for: .normal)
        view.titleLabel?.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 14)
        view.backgroundColor = .gray6
        view.tintColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .systemBackground
        [textLabel, subTextLabel, emailTextField, lineView, nextButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(80)
            make.leading.trailing.equalTo(self).inset(90)
            make.height.equalTo(32)
        }
        
        subTextLabel.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(8)
            make.leading.trailing.equalTo(self).inset(50)
            make.height.equalTo(26)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(subTextLabel.snp.bottom).offset(76)
            make.leading.trailing.equalTo(self).inset(28)
            make.height.equalTo(22)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(12)
            make.leading.trailing.equalTo(self).inset(16)
            make.height.equalTo(1)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(16)
            make.height.equalTo(48)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(UserDefaults.standard.float(forKey: "bottom"))
        }
    }
}

