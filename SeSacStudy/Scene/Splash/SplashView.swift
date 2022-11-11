//
//  SplashView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import UIKit

import SnapKit

final class SplashView: BaseView {
    
    let logoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "splash_logo")
        return view
    }()

    let textImageView: UIImageView = {
       let view = UIImageView()
        view.image = UIImage(named: "txt")
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .systemBackground
        [logoImageView, textImageView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(172)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(78)
            make.height.equalTo(264)
        }
        
        textImageView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(34)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(24)
            make.height.equalTo(112)
        }
    }
}
