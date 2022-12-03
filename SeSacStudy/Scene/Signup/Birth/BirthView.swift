//
//  BirthView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/09.
//

import UIKit

import SnapKit

final class BirthView: BaseView {
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalSpacing
        view.alignment = .top
        return view
    }()
    
    let textLabel: UILabel = {
        let view = UILabel()
        view.text = "생년월일을 알려주세요"
        view.textColor = .black
        view.font = .display1_R20
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
    
    let nextButton: BaseButton = {
        let view = BaseButton()
        view.setTitle("다음", for: .normal)
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
        [textLabel, yearView, nextButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [stackView, mounthView, dayView, datePicker].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        stackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide).inset(UIScreen.main.bounds.height * 0.07)
            make.bottom.equalTo(self).inset(UIScreen.main.bounds.height * 0.45)
        }
        
        textLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(22)
        }
        
        yearView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(99)
            make.height.equalTo(48)
        }
        
        mounthView.snp.makeConstraints { make in
            make.centerY.equalTo(yearView.snp.centerY)
            make.centerX.equalTo(self.snp.centerX)
            make.width.equalTo(99)
            make.height.equalTo(48)
        }
        
        dayView.snp.makeConstraints { make in
            make.centerY.equalTo(yearView.snp.centerY)
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(99)
            make.height.equalTo(48)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
        
        datePicker.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(216)
        }
    }
}
