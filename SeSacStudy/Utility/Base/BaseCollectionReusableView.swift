//
//  BaseCollectionReusableView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/22.
//

import UIKit

import SnapKit

final class BaseCollectionHeaderView: UICollectionReusableView {
    
    let label: UILabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .title6_R12
        view.textAlignment = .left
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
