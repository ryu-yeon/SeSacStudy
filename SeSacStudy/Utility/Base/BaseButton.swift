//
//  BaseButton.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/15.
//

import UIKit

class BaseButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(.white, for: .normal)
        self.titleLabel?.font = .body3_R14
        self.layer.cornerRadius = 8
        self.backgroundColor = .gray6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
