//
//  SesacShopTabViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/25.
//

import UIKit

import SnapKit

protocol SesacTabDelegate {
    func getSesacNumber(index: Int)
    func buySesac(index: Int)
}

final class SesacShopTabViewController: BaseViewController {
    
    let mainView = SesacShopTabView()
    
    var sesacDelegate: SesacTabDelegate?
    
    var user: User?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collecionView.dataSource = self
        mainView.collecionView.delegate = self
    }
}

extension SesacShopTabViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SesacItem.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SesacCollectionViewCell.reusableIdentifier, for: indexPath) as? SesacCollectionViewCell else { return UICollectionViewCell() }
        
        guard let user else { return UICollectionViewCell() }
        
        if user.sesacCollection.contains(indexPath.item) {
            cell.buyButton.backgroundColor = .gray2
            cell.buyButton.setTitleColor(.gray7, for: .normal)
            cell.buyButton.setTitle("보유", for: .normal)
            cell.buyButton.isEnabled = false
        } else {
            cell.buyButton.setTitle(SesacItem.list[indexPath.item].price, for: .normal)
        }
        cell.buyButton.tag = indexPath.item
        cell.buyButton.addTarget(self, action: #selector(buyButtonClicked), for: .touchUpInside)
        cell.sesacImageView.image = UIImage(named: SesacItem.list[indexPath.row].sesac.image)
        cell.titleLabel.text = SesacItem.list[indexPath.item].title
        cell.detailLabel.text = SesacItem.list[indexPath.item].detail
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sesacDelegate?.getSesacNumber(index: indexPath.item)
    }
    
    @objc func buyButtonClicked(_ sender: UIButton) {
        sesacDelegate?.buySesac(index: sender.tag)
    }
}
