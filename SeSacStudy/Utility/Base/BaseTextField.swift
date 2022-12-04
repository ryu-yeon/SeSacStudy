//
//  BaseTextField.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/15.
//

import UIKit

import SnapKit

class BaseTextField: BaseView {
    
    let textField: UITextField = {
        let view = UITextField()
        view.font = .title4_R14
        view.borderStyle = .none
        view.keyboardType = .default
        view.textColor = .black
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray3
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .clear
        [textField, lineView].forEach {
            self.addSubview($0)
        }
        setLine()
    }
    
    override func setConstraints() {
        
        textField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(13)
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(16)
        }
        
        lineView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setLine() {
        if textField.text == "" {
            lineView.backgroundColor = .gray3
        } else {
            lineView.backgroundColor = .black
        }
    }
}

