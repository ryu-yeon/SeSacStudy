//
//  MyInfoView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import UIKit

import SnapKit

final class MyInfoView: BaseView {
    
    let tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        view.separatorColor = .gray2
        view.rowHeight = 74
        view.isScrollEnabled = false
        view.register(MyInfoTableViewCell.self, forCellReuseIdentifier: MyInfoTableViewCell.reusableIdentifier)
        return view
    }()

    override func configureUI() {
        self.backgroundColor = .systemBackground
        self.addSubview(tableView)
    }
    
    override func setConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(24)
            make.leading.equalTo(self).inset(17)
            make.trailing.equalTo(self).inset(15)
            make.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
