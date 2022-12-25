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
}

final class SesacShopTabViewController: BaseViewController {
    
    let mainView = SesacShopTabView()
    
    var sesacDelegate: SesacTabDelegate?
    
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
        cell.sesacImageView.image = UIImage(named: SesacItem.list[indexPath.row].sesac.image)
        cell.buyButton.setTitle(SesacItem.list[indexPath.row].price, for: .normal)
        cell.titleLabel.text = SesacItem.list[indexPath.row].title
        cell.detailLabel.text = SesacItem.list[indexPath.row].detail
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sesacDelegate?.getSesacNumber(index: indexPath.item)
    }
}
