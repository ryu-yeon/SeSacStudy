//
//  BirthView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/09.
//

import UIKit

import SnapKit

final class BirthView: BaseView {
    
    let textLabel: UILabel = {
        let view = UILabel()
        view.text = "생년월일을 알려주세요"
        view.textColor = .black
        view.font = UIFont(name: Font.NotoSansRegular.rawValue, size: 20)
        view.setLineHeight(lineHeight: 1.08)
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    

    let yearView: DateView = {
        let view = DateView()
        view.unitLabel.text = "년"
        return view
    }()
    
    let mounthView: DateView = {
        let view = DateView()
        view.unitLabel.text = "월"
        return view
    }()
    
    let dayView: DateView = {
        let view = DateView()
        view.unitLabel.text = "일"
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
    
    let datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.preferredDatePickerStyle = .wheels
        view.datePickerMode = .date
        view.locale = Locale(identifier: "ko-KR")
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .systemBackground
        [textLabel, yearView, mounthView, dayView, nextButton, datePicker].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(97)
            make.leading.trailing.equalTo(self).inset(90)
            make.height.equalTo(22)
        }
        
        yearView.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(80)
            make.leading.equalTo(self).offset(16)
            make.width.equalTo(99)
            make.height.equalTo(48)
        }
        
        mounthView.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(80)
            make.centerX.equalTo(self)
            make.width.equalTo(99)
            make.height.equalTo(48)
        }
        
        dayView.snp.makeConstraints { make in
            make.top.equalTo(textLabel.snp.bottom).offset(80)
            make.trailing.equalTo(self).offset(-16)
            make.width.equalTo(99)
            make.height.equalTo(48)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(yearView.snp.bottom).offset(72)
            make.leading.trailing.equalTo(self).inset(16)
            make.height.equalTo(48)
        }
        
        datePicker.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(self)
            make.height.equalTo(216)
        }
    }
}
