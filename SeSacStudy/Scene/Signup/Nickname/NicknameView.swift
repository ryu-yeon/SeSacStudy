//
//  NicknameView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/09.
//

import UIKit

import SnapKit

final class NicknameView: BaseView {
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .top
        return view
    }()
    
    let textLabel: UILabel = {
        let view = UILabel()
        view.text = "닉네임을 입력해 주세요"
        view.textColor = .black
        view.font = .display1_R20
        view.setLineHeight(lineHeight: 1.08)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let nicknameTextField: BaseTextField = {
        let view = BaseTextField()
        view.textField.placeholder = "10자 이내로 입력"
        return view
    }()
    
    let nextButton: BaseButton = {
        let view = BaseButton()
        view.setTitle("다음", for: .normal)
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .systemBackground
        [textLabel, nicknameTextField, nextButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        self.addSubview(stackView)
    }
    
    override func setConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide).inset(UIScreen.main.bounds.height * 0.1)
            make.bottom.equalTo(self).inset(UIScreen.main.bounds.height * 0.48)
        }
        
        textLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(32)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
}
