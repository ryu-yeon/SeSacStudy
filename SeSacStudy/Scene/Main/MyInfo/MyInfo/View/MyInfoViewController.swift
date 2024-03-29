//
//  MyInfoViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import UIKit

import RxCocoa
import RxSwift

final class MyInfoViewController: BaseViewController {
    
    private let mainView = MyInfoView()
    let viewModel = MyInfoViewModel()
    private let disposeBag = DisposeBag()
    
    var user: User?
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setTableView()
    }
    
    private func setTableView() {
        
        viewModel.list
            .bind(to: mainView.tableView.rx.items(cellIdentifier: MyInfoTableViewCell.reusableIdentifier, cellType: MyInfoTableViewCell.self)) {
                (index, item, cell) in
                if index == 0 {
                    cell.profileImageView.isHidden = false
                    cell.arrowImagView.isHidden = false
                    cell.titleLabel.textColor = .black
                    cell.titleLabel.font = .title1_M16
                    let sesac = SesacImage(rawValue: self.viewModel.user?.sesac ?? 0) ?? .sesac_face_1
                    cell.profileImageView.image = UIImage(named: sesac.image)
                    cell.iconImageView.snp.updateConstraints { make in
                        make.width.height.equalTo(50)
                    }
                }
                cell.iconImageView.image = UIImage(named: item.icon)
                cell.titleLabel.text = item.title
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        mainView.tableView.rx.itemSelected
            .withUnretained(self)
            .bind { (vc, item) in
                if item.row == 0 {
                    let nextVC = SetInfoViewController()
                    vc.navigationController?.pushViewController(nextVC, animated: true)
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.fetch()
    }
    
    override func setNavigationBar() {
        navigationItem.title = "내정보"
    }
}

extension MyInfoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 96
        } else {
            return 74
        }
    }
}
