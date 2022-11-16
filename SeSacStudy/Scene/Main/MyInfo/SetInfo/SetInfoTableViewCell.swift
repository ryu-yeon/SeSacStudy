//
//  SetInfoTableViewCell.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/14.
//

import UIKit

import SnapKit
import MultiSlider

protocol SITVCDelegate: AnyObject {
    func sendRange(ageMin: Int, ageMax: Int)
    func sendSearchable(searchable: Int)
}

final class SetInfoTableViewCell: BaseTableViewCell {
    
    
    weak var delegate: SITVCDelegate?
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .title4_R14
        view.textAlignment = .left
        return view
    }()
    
    let manButton: BaseButton = {
        let view = BaseButton()
        view.layer.borderColor = UIColor.gray4.cgColor
        view.layer.borderWidth = 1
        view.setTitleColor(.black, for: .normal)
        view.backgroundColor = .white
        view.setTitle("남자", for: .normal)
        view.isHidden = true
        return view
    }()
    
    let womanButton: BaseButton = {
        let view = BaseButton()
        view.layer.borderColor = UIColor.gray4.cgColor
        view.layer.borderWidth = 1
        view.setTitleColor(.black, for: .normal)
        view.backgroundColor = .white
        view.setTitle("여자", for: .normal)
        view.isHidden = true
        return view
    }()
    
    let titleTextField: BaseTextField = {
        let view = BaseTextField()
        view.textField.placeholder = "스터디를 입력해 주세요"
        view.isHidden = true
        return view
    }()
    
    let numberSwitch: UISwitch = {
        let view = UISwitch()
        view.tintColor = .brandGreen
        view.isHidden = true
        return view
    }()
    
    let ageSlider: MultiSlider = {
        let view = MultiSlider()
        view.minimumValue = 18
        view.maximumValue = 65
        view.outerTrackColor = .gray2
        view.thumbImage = UIImage(named: "filter_control")
        view.tintColor = .brandGreen
        view.orientation = .horizontal
        view.isHidden = true
        return view
    }()
    
    var rangeLabel: UILabel = {
        let view = UILabel()
        view.textColor = .brandGreen
        view.font = .title3_M14
        view.isHidden = true
        return view
    }()
    
    override func configureUI() {
        contentView.backgroundColor = .clear
        [titleLabel, manButton, womanButton, titleTextField, numberSwitch, rangeLabel, ageSlider].forEach {
            contentView.addSubview($0)
            self.selectionStyle = .none
        }
        
        numberSwitch.addTarget(self, action: #selector(switchValueChanged), for: .valueChanged)
        ageSlider.addTarget(self, action: #selector(sliderChanged), for: .valueChanged)
    }
    
    @objc func switchValueChanged() {
        delegate?.sendSearchable(searchable: numberSwitch.isOn ? 1 : 0)
    }
    
    @objc func sliderChanged() {
        let ageMin = Int(ageSlider.value[0])
        let ageMax = Int(ageSlider.value[1])
        rangeLabel.text = "\(ageMin) - \(ageMax)"
        delegate?.sendRange(ageMin: ageMin, ageMax: ageMax)
    }
    
    override func layoutSubviews() {
      super.layoutSubviews()
      contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0))
        
    }
    
    override func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(13)
            make.leading.equalToSuperview()
            make.height.equalTo(22)
        }
        
        womanButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(56)
        }
        
        manButton.snp.makeConstraints { make in
            make.trailing.equalTo(womanButton.snp.leading).offset(-8)
            make.verticalEdges.equalToSuperview()
            make.width.equalTo(56)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.width.equalTo(184)
            make.height.equalTo(48)
        }
        
        numberSwitch.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(52)
            make.height.equalTo(28)
        }
        
        rangeLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(11)
        }
        
        ageSlider.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(24)
        }
    }
}
