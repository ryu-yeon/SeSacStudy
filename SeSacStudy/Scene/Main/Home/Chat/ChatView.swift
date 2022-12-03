//
//  ChatView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/17.
//

import UIKit

import SnapKit

final class ChatView: BaseView {
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.font = .title5_M12
        view.textColor = .white
        view.backgroundColor = .gray7
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.textAlignment = .center
        return view
    }()
    
    let iconImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "bell")
        view.tintColor = .gray7
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.font = .title3_M14
        view.textColor = .gray7
        view.textAlignment = .center
        return view
    }()
    
    let subTitleLabel: UILabel = {
        let view = UILabel()
        view.font = .title4_R14
        view.text = "채팅을 통해 약속을 정해보세요 :)"
        view.textColor = .gray6
        view.textAlignment = .center
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.allowsSelection = false
        view.separatorStyle = .none
        view.rowHeight = UITableView.automaticDimension
        view.register(MyChatTableViewCell.self, forCellReuseIdentifier: MyChatTableViewCell.reusableIdentifier)
        view.register(YourChatTableViewCell.self, forCellReuseIdentifier: YourChatTableViewCell.reusableIdentifier)
        view.backgroundColor = .clear
        return view
    }()
    
    let textContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .gray1
        view.layer.cornerRadius = 8
        return view
    }()
    
    let textView: UITextView = {
        let view = UITextView()
        view.backgroundColor = .clear
        return view
    }()
    
    let sendButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "send_inact"), for: .normal)
        view.backgroundColor = .clear
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    let reportButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "report"), for: .normal)
        view.setImage(UIImage(named: "report"), for: .highlighted)
        return view
    }()
    
    let cancleButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "cancle"), for: .normal)
        view.setImage(UIImage(named: "cancle"), for: .highlighted)
        return view
    }()
    
    let reviewButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "review"), for: .normal)
        view.setImage(UIImage(named: "review"), for: .highlighted)
        return view
    }()
    
    let view: UIView = {
        let view = UIView()
        view.isHidden = true
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .systemBackground
        
        [reportButton, cancleButton, reviewButton].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [dateLabel, iconImageView, titleLabel, subTitleLabel, tableView, textContainer, textView, sendButton, view, stackView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(114)
            make.height.equalTo(28)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(titleLabel.snp.leading).offset(-4)
            make.size.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview().offset(20)
            make.height.equalTo(22)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.height.equalTo(22)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(textContainer.snp.top).offset(-8)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(72)
        }
        
        view.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaInsets).offset(126)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        textContainer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(52)
        }
        
        textView.snp.makeConstraints { make in
            make.centerY.equalTo(textContainer.snp.centerY)
            make.leading.equalTo(textContainer).inset(12)
            make.trailing.equalTo(textContainer).inset(44)
            make.height.equalTo(24)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(textContainer.snp.centerY)
            make.trailing.equalTo(textContainer).inset(16)
            make.size.equalTo(20)
        }
        
        reportButton.snp.makeConstraints { make in
            make.width.equalTo(125)
            make.height.equalTo(72)
        }
        
        cancleButton.snp.makeConstraints { make in
            make.width.equalTo(125)
            make.height.equalTo(72)
        }
        
        reviewButton.snp.makeConstraints { make in
            make.width.equalTo(125)
            make.height.equalTo(72)
        }
    }
}
