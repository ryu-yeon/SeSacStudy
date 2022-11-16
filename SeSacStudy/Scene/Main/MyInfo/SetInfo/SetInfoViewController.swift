//
//  SetInfoViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/14.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class SetInfoViewController: BaseViewController {
    
    private let mainView = SetInfoView()
    let viewModel = SetInfoViewModel()
    private let disposeBag = DisposeBag()
    
    var isClicked = false
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setNavigationBar()
        setBackButton()
        
        navigationItem.rightBarButtonItem?.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                let idToken = UserDefaultsHelper.standard.idToken
                vc.viewModel.apiService.updateMyPage(user: vc.viewModel.user, idToken: idToken) { statusCode in
                    vc.checkStatusCode(statusCode)
                }
            }
            .disposed(by: disposeBag)
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        mainView.tableView.register(CardTableViewCell.self, forCellReuseIdentifier: CardTableViewCell.reusableIdentifier)
        mainView.tableView.register(SetInfoTableViewCell.self, forCellReuseIdentifier: SetInfoTableViewCell.reusableIdentifier)
        
    }
    
    private func checkStatusCode(_ statusCode: Int) {
        switch statusCode {
        case 200:
            UserDefaultsHelper.standard.saveUser(user: self.viewModel.user)
            self.navigationController?.popViewController(animated: true)
            print("저장 성공🟢")
        case 401:
            viewModel.firebaseAuthManager.getIdToken { [weak self] idToken in
                if let idToken {
                    self?.viewModel.apiService.updateMyPage(user: (self?.viewModel.user)!, idToken: idToken) { statusCode in
                        self?.checkStatusCode(statusCode)
                    }
                }
            }
            print("Firebase Token Error🔴")
        case 406:
            print("미가입 유저😀")
        case 500:
            print("Server Error🔴")
        case 501:
            print("Client Error🔴")
        default:
            break
        }
    }
    
    override func setNavigationBar() {
        navigationItem.title = "정보 관리"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: nil, action: nil)
    }
    
    @objc func moreButtonClicked() {
        isClicked = !isClicked
        mainView.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    @objc func textInput() {
        mainView.tableView.scrollsToTop = true
    }
    
    @objc func manButtonClicked() {
        viewModel.user.gender = 1
        mainView.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
    }
    
    @objc func womanButtonClicked() {
        viewModel.user.gender = 0
        mainView.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
    }
}

extension SetInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 4
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTableViewCell.reusableIdentifier, for: indexPath) as? CardTableViewCell else { return UITableViewCell() }
            
            cell.infoView.moreButton.addTarget(self, action: #selector(moreButtonClicked), for: .touchUpInside)
            cell.backgroundImageView.image = UIImage(named: "sesac_background_\(viewModel.user.background)")
            cell.profileImageView.image = UIImage(named: "sesac_face_\(viewModel.user.sesac)")
            cell.infoView.nicknameLabel.text = viewModel.user.nick
            cell.infoView.titleLabel.isHidden = !isClicked
            cell.infoView.collectionView.isHidden = !isClicked
            cell.infoView.reviewLabel.isHidden = !isClicked
            cell.infoView.reviewTextView.isHidden = !isClicked
            
            let buttonImage = isClicked ? UIImage(named: "less") : UIImage(named: "more")
            cell.infoView.moreButton.setImage(buttonImage, for: .normal)
            
            cell.infoView.list = viewModel.user.reputation
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SetInfoTableViewCell.reusableIdentifier, for: indexPath) as? SetInfoTableViewCell else { return UITableViewCell() }
            cell.titleLabel.text = viewModel.list[indexPath.row]
            cell.delegate = self
            switch indexPath.row {
            case 0:
                if viewModel.user.gender == 0 {
                    cell.womanButton.backgroundColor = .brandGreen
                    cell.womanButton.setTitleColor(.white, for: .normal)
                    cell.womanButton.layer.borderWidth = 0
                    cell.manButton.backgroundColor = .white
                    cell.manButton.setTitleColor(.black, for: .normal)
                    cell.manButton.layer.borderWidth = 1
                } else {
                    cell.womanButton.backgroundColor = .white
                    cell.womanButton.setTitleColor(.black, for: .normal)
                    cell.womanButton.layer.borderWidth = 1
                    cell.manButton.backgroundColor = .brandGreen
                    cell.manButton.setTitleColor(.white, for: .normal)
                    cell.manButton.layer.borderWidth = 0
                }
                cell.womanButton.isHidden = false
                cell.manButton.isHidden = false
                cell.manButton.addTarget(self, action: #selector(manButtonClicked), for: .touchUpInside)
                cell.womanButton.addTarget(self, action: #selector(womanButtonClicked), for: .touchUpInside)
            case 1:
                cell.titleTextField.isHidden = false
            case 2:
                cell.numberSwitch.isHidden = false
                cell.numberSwitch.isOn = viewModel.user.searchable == 1

            case 3:
                cell.ageSlider.isHidden = false
                cell.ageSlider.value = [CGFloat(viewModel.user.ageMin), CGFloat(viewModel.user.ageMax)]
                cell.rangeLabel.isHidden = false
                cell.rangeLabel.text = "\(viewModel.user.ageMin) - \(viewModel.user.ageMax)"
            default:
                break
            }
            return cell
            
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SetInfoTableViewCell.reusableIdentifier, for: indexPath) as? SetInfoTableViewCell else { return UITableViewCell() }
            cell.titleLabel.text = "회원탈퇴"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case IndexPath(row: 0, section: 0):
            if isClicked {
                return 504
            } else {
                return 252
            }
        case IndexPath(row: 3, section: 1):
            return 80
        default:
            return 64
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        switch section {
        case 0:
            return 0
        case 1:
            return 24
        default:
            return 8
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath {
        case IndexPath(row: 0, section: 2):
            let nextVC = PopupViewController()
            nextVC.setTitle(title: "정말 탈퇴하시겠습니까?")
            nextVC.setSubtitle(subtitle: "탈퇴하시면 새싹 스터디를 이용할 수 없어요ㅠ")
            nextVC.withDraw()
            nextVC.modalPresentationStyle = .overFullScreen
            present(nextVC, animated: true)
        default:
            break
        }
    }
    

}

extension SetInfoViewController: SITVCDelegate {
    func sendRange(ageMin: Int, ageMax: Int) {
        viewModel.user.ageMin = ageMin
        viewModel.user.ageMax = ageMax
    }
    
    func sendSearchable(searchable: Int) {
        viewModel.user.searchable = searchable
    }
    
    
}
