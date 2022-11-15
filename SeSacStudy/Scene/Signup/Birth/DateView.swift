//
//  DateView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/09.
//

import UIKit

import SnapKit

final class DateView: BaseView {
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .left
        view.textColor = .gray7
        view.font = .body3_R14
        return view
    }()
    
    let unitLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .right
        view.textColor = .black
        view.font = .body3_R14
        return view
    }()
    
    let lineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray6
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .clear
        [dateLabel, unitLabel, lineView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.leading.equalTo(self).offset(12)
            make.trailing.equalTo(unitLabel.snp.leading).offset(-4)
            make.height.equalTo(22)
        }
        
        unitLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.trailing.equalTo(self)
            make.width.equalTo(15)
            make.height.equalTo(26)
        }
        
        lineView.snp.makeConstraints { make in
            make.bottom.equalTo(self)
            make.leading.equalTo(self)
            make.trailing.equalTo(unitLabel.snp.leading).offset(-4)
            make.height.equalTo(1)
        }
    }
}
