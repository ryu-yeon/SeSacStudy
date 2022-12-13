//
//  MyChatTableViewCell.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/01.
//

import UIKit

import SnapKit

final class MyChatTableViewCell: BaseTableViewCell {
    
    let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = .whiteGreen
        return view
    }()
    
    let chatLabel: UILabel = {
        let view = UILabel()
        view.font = .body3_R14
        view.setLineHeight(lineHeight: 1.15)
        view.textColor = .black
        view.textAlignment = .left
        view.numberOfLines = 0
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.textColor = .gray6
        view.font = .title6_R12
        return view
    }()
    
    override func configureUI() {
        [bubbleView, chatLabel, dateLabel].forEach {
            contentView.addSubview($0)
        }
        contentView.backgroundColor = .clear
    }
    
    override func setConstraints() {
        
        bubbleView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(16)
            make.leading.greaterThanOrEqualToSuperview().inset(95)
        }
        
        chatLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(bubbleView).inset(10)
            make.horizontalEdges.equalTo(bubbleView).inset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(bubbleView.snp.bottom)
            make.trailing.equalTo(bubbleView.snp.leading).offset(-8)
            make.width.equalTo(30)
            make.height.equalTo(18)
        }
    }
}
