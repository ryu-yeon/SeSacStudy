//
//  GenderView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import UIKit

import SnapKit

final class GenderView: BaseView {
    
    let textLabel: UILabel = {
        let view = UILabel()
        view.text = "성별을 선택해 주세요"
        view.textColor = .black
        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 20)
        view.setLineHeight(lineHeight: 1.08)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let subTextLabel: UILabel = {
        let view = UILabel()
        view.text = "새싹 찾기 기능을 이용하기 위해서 필요해요!"
        view.textColor = .gray7
        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 16)
        view.setLineHeight(lineHeight: 1.08)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    let manButton: UIButton = {
        let view = UIButton()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray3.cgColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.tintColor = .black
        return view
    }()
    
    let manImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "man")
        return view
    }()
    
    let manLabel: UILabel = {
        let view = UILabel()
        view.text = "남자"
        view.textColor = .black
        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 16)
        return view
    }()
    
    let womanButton: UIButton = {
        let view = UIButton()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.gray3.cgColor
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.tintColor = .black
        return view
    }()
    
    let womanImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "woman")
        return view
    }()
    
    let womanLabel: UILabel = {
        let view = UILabel()
        view.text = "여자"
        view.textColor = .black
        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 16)
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
        [textLabel, subTextLabel, manButton, womanButton, manImageView, manLabel, womanImageView, womanLabel, nextButton].forEach {
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
        
        manButton.snp.makeConstraints { make in
            make.top.equalTo(subTextLabel.snp.bottom).offset(24)
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self.snp.centerX).offset(-6)
            make.height.equalTo(110)
        }
        
        manImageView.snp.makeConstraints { make in
            make.top.equalTo(manButton).inset(14)
            make.centerX.equalTo(manButton)
            make.width.height.equalTo(64)
        }

        manLabel.snp.makeConstraints { make in
            make.bottom.equalTo(manButton).inset(14)
            make.centerX.equalTo(manButton)
            make.width.equalTo(30)
            make.height.equalTo(26)
        }
        
        womanButton.snp.makeConstraints { make in
            make.top.equalTo(subTextLabel.snp.bottom).offset(24)
            make.leading.equalTo(self.snp.centerX).offset(6)
            make.trailing.equalTo(self).offset(-16)
            make.height.equalTo(110)
        }
        
        womanImageView.snp.makeConstraints { make in
            make.top.equalTo(womanButton).inset(14)
            make.centerX.equalTo(womanButton)
            make.width.height.equalTo(64)
        }
        
        womanLabel.snp.makeConstraints { make in
            make.bottom.equalTo(womanButton).inset(14)
            make.centerX.equalTo(womanButton)
            make.width.equalTo(30)
            make.height.equalTo(26)
        }
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(16)
            make.height.equalTo(48)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(UserDefaults.standard.float(forKey: "bottom"))
        }
    }
}

