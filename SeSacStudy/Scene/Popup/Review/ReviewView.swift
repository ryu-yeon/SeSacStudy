//
//  ReviewView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/13.
//

import UIKit

import SnapKit

final class ReviewView: BaseView {
    
    let popupContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        return view
    }()
    
    let cancleButton: UIButton = {
        let view = UIButton()
        view.tintColor = .gray6
        view.setImage(UIImage(named: "close_big"), for: .normal)
        return view
    }()
    
    let titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .black
        view.font = .body1_M16
        return view
    }()
    
    let subtitleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.textColor = .black
        view.numberOfLines = 0
        view.font = .title4_R14
        return view
    }()
    
    let titleCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = Int(UIScreen.main.bounds.width) - 56 - 32 - Int(spacing) * 3
        
        layout.itemSize = CGSize(width: width / 2, height: 32)
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 0, left: spacing, bottom: 0, right: spacing)
        
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.isScrollEnabled = false
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
        view.text =  "자세한 피드백은 다른 새싹들에게 도움이 됩니다 (500자 이내 작성)"
        view.font = .body3_R14
        view.textColor = .gray7
        view.textContainerInset = .zero 
        return view
    }()
    
    let okButton: BaseButton = {
        let view = BaseButton()
        view.setTitle("리뷰 등록하기", for: .normal)
        view.backgroundColor = .gray6
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        [popupContainer, cancleButton, titleLabel, subtitleLabel, titleCollectionView, textContainer, textView, okButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        popupContainer.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(450)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(popupContainer)
            make.top.equalTo(popupContainer).inset(16)
            make.horizontalEdges.equalTo(popupContainer).inset(16.5)
            make.height.equalTo(30)
        }
        
        cancleButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.trailing.equalTo(popupContainer).inset(16)
            make.size.equalTo(16)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalTo(popupContainer)
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(popupContainer).inset(16.5)
            make.height.equalTo(22)
        }
        
        titleCollectionView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(popupContainer).inset(16)
            make.height.equalTo(120)
        }
        
        textContainer.snp.makeConstraints { make in
            make.top.equalTo(titleCollectionView.snp.bottom).offset(24)
            make.horizontalEdges.equalTo(popupContainer).inset(16)
            make.height.equalTo(124)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(textContainer).inset(14)
            make.horizontalEdges.equalTo(textContainer).inset(12)
            make.bottom.equalTo(textContainer)
        }
        
        okButton.snp.remakeConstraints { make in
            make.top.equalTo(textContainer.snp.bottom).offset(16)
            make.horizontalEdges.equalTo(popupContainer).inset(16)
            make.height.equalTo(48)
        }
    }
    
    func updatePopupContainer(keyboardVisibleHeight: CGFloat) {
        popupContainer.snp.updateConstraints { make in
            make.center.equalToSuperview().offset(-keyboardVisibleHeight / 2)
        }
    }
}
