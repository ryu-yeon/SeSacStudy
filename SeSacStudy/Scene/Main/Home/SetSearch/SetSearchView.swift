//
//  SetSearchView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/17.
//

import UIKit

import SnapKit

final class SetSearchView: BaseView {
    
    
    let searchButton: BaseButton = {
        let view = BaseButton()
        view.setTitle("새싹 찾기", for: .normal)
        view.backgroundColor = .brandGreen
        return view
    }()

    override func configureUI() {
        
        self.backgroundColor = .systemBackground
        [searchButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        searchButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(50)
            make.height.equalTo(48)
        }
    }
}
