//
//  NicknameView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/09.
//

import UIKit

import SnapKit

final class NicknameView: BaseView {
    
    let textLabel: UILabel = {
        let view = UILabel()
        view.text = "닉네임을 입력해 주세요"
        view.textColor = .black
        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 20)
        view.setLineHeight(lineHeight: 1.08)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let nicknameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "10자 이내로 입력"
        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 14)
        view.borderStyle = .none
        view.keyboardType = .default
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray6
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
        [textLabel, nicknameTextField, lineView, nextButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(97)
            make.leading.trailing.equalTo(self).inset(90)
            make.height.equalTo(32)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(93)
            make.leading.trailing.equalTo(self).inset(28)
            make.height.equalTo(22)
        }
        
        lineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            make.leading.trailing.equalTo(self).inset(16)
            make.height.equalTo(1)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(lineView.snp.bottom).offset(72)
            make.leading.trailing.equalTo(self).inset(16)
            make.height.equalTo(48)
        }
    }
}
