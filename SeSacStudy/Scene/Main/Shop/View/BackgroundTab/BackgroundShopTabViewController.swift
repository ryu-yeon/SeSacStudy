//
//  BackgroundShopTabViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/25.
//

import UIKit

protocol BackgroundTabDelegate {
    func getBackgroundNumber(index: Int)
}

final class BackgroundShopTabViewController: BaseViewController {
    
    let mainView = BackgroundShopTabView()
    
    var backgroundDelegate: BackgroundTabDelegate?
    
    override func loadView() {
        self.view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.collecionView.dataSource = self
        mainView.collecionView.delegate = self
    }
}

extension BackgroundShopTabViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BackgroundItem.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BackgroundCollectionViewCell.reusableIdentifier, for: indexPath) as? BackgroundCollectionViewCell else { return UICollectionViewCell() }
        cell.backgroundImageView.image = UIImage(named: BackgroundItem.list[indexPath.row].background.image)
        cell.buyButton.setTitle(BackgroundItem.list[indexPath.row].price, for: .normal)
        cell.titleLabel.text = BackgroundItem.list[indexPath.row].title
        cell.detailLabel.text = BackgroundItem.list[indexPath.row].detail
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        backgroundDelegate?.getBackgroundNumber(index: indexPath.item)
    }
}
