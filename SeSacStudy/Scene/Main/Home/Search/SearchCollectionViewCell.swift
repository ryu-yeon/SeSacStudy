//
//  SearchCollectionViewCell.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/27.
//

import UIKit

import SnapKit


protocol SCVDelegate {
    func goToVC(index: Int, request: Bool, uid: String)
}

final class SearchCollectionViewCell: BaseCollectionViewCell {
    
    var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.sectionHeaderTopPadding = 0
        
        view.backgroundColor = .clear
        view.isHidden = true
        return view
    }()
    
    let emptyImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "empty_img")
        view.isHidden = true
        return view
    }()
    
    let changeButton: BaseButton = {
        let view = BaseButton()
        view.setTitle("스터디 변경하기", for: .normal)
        view.backgroundColor = .brandGreen
        view.isHidden = true
        return view
    }()
    
    let refreshButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "refresh"), for: .normal)
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.brandGreen.cgColor
        view.layer.borderWidth = 1
        view.isHidden = true
        return view
    }()
    
    var sesacList: [Sesac] = []
    
    var isClicked: [Bool] = []
    
    var buttonColor: UIColor?
    
    var text: String?
    
    var delegate: SCVDelegate?
    
    var request: Bool?
    
    override func configureUI() {
        contentView.backgroundColor = .clear
        [tableView, emptyImageView, changeButton, refreshButton].forEach {
            contentView.addSubview($0)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.reusableIdentifier)
        
    }
    
    override func setConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(44)
            make.bottom.equalTo(self.safeAreaLayoutGuide).offset(-50)
            make.horizontalEdges.equalToSuperview().inset(16)
        }
        
        emptyImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(265)
            make.height.equalTo(158)
        }
        
        changeButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(50)
            make.leading.equalToSuperview().inset(16)
            make.height.equalTo(44)
            make.trailing.equalTo(refreshButton.snp.leading).offset(-8)
        }
        
        refreshButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(changeButton.snp.centerY)
            make.size.equalTo(48)
        }
    }
}

extension SearchCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sesacList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.reusableIdentifier, for: indexPath) as? CardTableViewCell else { return UITableViewCell() }
        cell.infoView.moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
        
        cell.infoView.moreButton.tag = indexPath.section
        cell.requestButton.isHidden = false
        cell.requestButton.backgroundColor = buttonColor
        cell.requestButton.setTitle(text, for: .normal)
        cell.requestButton.tag = indexPath.section
        cell.requestButton.addTarget(self, action: #selector(requestButtonClicked), for: .touchUpInside)
        
        cell.backgroundImageView.image = UIImage(named: "sesac_background_\(sesacList[indexPath.section].background + 1)")
        cell.profileImageView.image = UIImage(named: "sesac_face_\(sesacList[indexPath.section].sesac + 1)")
        
        cell.infoView.nicknameLabel.text = sesacList[indexPath.section].nick
        cell.infoView.list = sesacList[indexPath.section].reputation
        cell.infoView.titleLabel.isHidden = !isClicked[indexPath.section]
        cell.infoView.titleCollectionView.isHidden = !isClicked[indexPath.section]
        cell.infoView.studyLabel.isHidden = !isClicked[indexPath.section]
        cell.infoView.studyCollectionView.isHidden = !isClicked[indexPath.section]
        cell.infoView.reviewLabel.isHidden = !isClicked[indexPath.section]
        cell.infoView.reviewTextLabel.isHidden = !isClicked[indexPath.section]

        let buttonImage = isClicked[indexPath.section] ? UIImage(named: "less") : UIImage(named: "more")
        cell.infoView.moreButton.setImage(buttonImage, for: .normal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isClicked[indexPath.section] {
            return 488 + 60
        } else {
            return 252
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    @objc func moreButtonClicked(sender: UIButton) {
        isClicked[sender.tag] = !isClicked[sender.tag]
        tableView.reloadRows(at: [IndexPath(item: 0, section: sender.tag)], with: .none)
    }
    
    @objc func requestButtonClicked(sender: UIButton) {
        delegate?.goToVC(index: sender.tag, request: request ?? false, uid: sesacList[sender.tag].uid)
    }
}

