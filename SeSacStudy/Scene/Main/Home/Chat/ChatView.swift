//
//  ChatView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/17.
//

import UIKit

import SnapKit

final class ChatView: BaseView {

    let collectionView: UICollectionView = {
        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        configuration.showsSeparators = false
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
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
        
        [collectionView, textContainer, textView, sendButton, view, stackView].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaInsets).offset(126)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
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
            make.bottom.equalToSuperview().inset(50)
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
