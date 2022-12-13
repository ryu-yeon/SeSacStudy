//
//  SearchViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/17.
//

import UIKit

import RxCocoa
import RxSwift
import Toast

final class SearchViewController: BaseViewController {
    
    private let mainView = SearchView()
    let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    var timer = Timer()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.searchSasac()
        
        setNavigationBar()
        setRootButton()
        setCollectionView()
        setPageButton()
        bindMyStatus()
        
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(checkStatus), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func setNavigationBar() {
        navigationItem.title = "새싹찾기"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopButonClicked))
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer.invalidate()
    }
    
    private func setPageButton() {
        mainView.collectionView.rx.willEndDragging
            .bind { [self] (velocity, targetContentOffset) in
                let page = Int(targetContentOffset.pointee.x / self.mainView.frame.width)
                
                viewModel.page.accept(Page(rawValue: page) ?? .nearSesac)
            }
            .disposed(by: disposeBag)
        
        mainView.nearButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.page.accept(.nearSesac)
            }
            .disposed(by: disposeBag)
        
        mainView.recieveButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.page.accept(.request)
            }
            .disposed(by: disposeBag)
        
        viewModel.page
            .asDriver(onErrorJustReturn: .nearSesac)
            .drive { [self] page in
                switch page {
                case .nearSesac:
                    mainView.nearButton.setTitleColor(.brandGreen, for: .normal)
                    mainView.lineView.backgroundColor = .brandGreen
                    mainView.recieveButton.setTitleColor(.gray6, for: .normal)
                    mainView.lineView2.backgroundColor = .gray6
                case .request:
                    mainView.nearButton.setTitleColor(.gray6, for: .normal)
                    mainView.lineView.backgroundColor = .gray6
                    mainView.recieveButton.setTitleColor(.brandGreen, for: .normal)
                    mainView.lineView2.backgroundColor = .brandGreen
                }
                let index = IndexPath(item: page.rawValue, section: .zero)
                let rect = mainView.collectionView.layoutAttributesForItem(at: index)?.frame
                mainView.collectionView.scrollRectToVisible(rect ?? .zero, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindMyStatus() {
        viewModel.myStatus
            .asDriver(onErrorJustReturn: nil)
            .drive { value in
                if value?.matched == 1 {
                    let nextVC = ChatViewController()
                    nextVC.viewModel.yourNickname = value?.matchedNick ?? ""
                    nextVC.viewModel.yourID = value?.matchedUid ?? ""
                    self.mainView.makeToast("\(value?.matchedNick ?? "")님과 매칭되셨습니다. 잠시후 채팅방으로 이동합니다.", duration: 1.0, position: .top)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.navigationController?.pushViewController(nextVC, animated:  true)
                    }                    
                }
            }
            .disposed(by: disposeBag)
    }
    
    @objc func checkStatus() {
        viewModel.checkMyStatus()
    }
    
    @objc func stopButonClicked() {
        viewModel.stopSearch()
        guard let viewControllerStack = self.navigationController?.viewControllers else { return }
        for viewController in viewControllerStack {
            self.navigationController?.popToViewController(viewController, animated: true)
        }
    }
    
    private func setCollectionView() {
        viewModel.data
            .bind(to: mainView.collectionView.rx.items(cellIdentifier: SearchCollectionViewCell.reusableIdentifier, cellType: SearchCollectionViewCell.self)) { [self] (index, item, cell) in
                let page = Page(rawValue: index)
                switch page {
                case .nearSesac:
                    if item.isEmpty {
                        cell.changeButton.isHidden = false
                        cell.refreshButton.isHidden = false
                        cell.emptyImageView.isHidden = false
                        cell.tableView.isHidden = true
                    } else {
                        cell.changeButton.isHidden = true
                        cell.refreshButton.isHidden = true
                        cell.emptyImageView.isHidden = true
                        cell.tableView.isHidden = false
                        cell.sesacList = item
                        cell.isClicked = [Bool](repeating: false, count: item.count)
                        cell.buttonColor = .errorColor
                        cell.text = "요청하기"
                        cell.request = true
                    }
                case .request:
                    if item.isEmpty {
                        cell.changeButton.isHidden = false
                        cell.refreshButton.isHidden = false
                        cell.emptyImageView.isHidden = false
                        cell.tableView.isHidden = true
                    } else {
                        cell.changeButton.isHidden = true
                        cell.refreshButton.isHidden = true
                        cell.emptyImageView.isHidden = true
                        cell.tableView.isHidden = false
                        cell.sesacList = item
                        cell.isClicked = [Bool](repeating: false, count: item.count)
                        cell.buttonColor = .successColor
                        cell.text = "수락하기"
                        cell.request = false
                    }
                case .none:
                    break
                }
                
                cell.delegate = self
                
                cell.changeButton.rx.tap
                    .withUnretained(self)
                    .bind { (vc, _) in
                        let nextVC = SetSearchViewController()
                        vc.viewModel.stopSearch()
                        vc.viewModel.searchSasac()
                        nextVC.viewModel.searchData = vc.viewModel.searchData
                        nextVC.viewModel.coordinate = vc.viewModel.coordinate
                        vc.navigationController?.pushViewController(nextVC, animated: true)
                    }
                    .disposed(by: disposeBag)
                
//                cell.refreshButton.rx.tap
//                    .withUnretained(self)
//                    .bind { (vc, _) in
//                        vc.viewModel.searchSasac()
//                    }
//                    .disposed(by: disposeBag)
//
//                cell.changeButton.addTarget(self, action: #selector(changeButtonClicked), for: .touchUpInside)
//                cell.refreshButton.addTarget(self, action: #selector(refreshButtonClicked), for: .touchUpInside)
            }
            .disposed(by: disposeBag)
        
    }
    
//    @objc func changeButtonClicked() {
//        let nextVC = SetSearchViewController()
//        viewModel.stopSearch()
//        viewModel.searchSasac()
//        nextVC.viewModel.searchData = viewModel.searchData
//        nextVC.viewModel.coordinate = viewModel.coordinate
//        self.navigationController?.pushViewController(nextVC, animated: true)
//    }
//
//    @objc func refreshButtonClicked() {
//        viewModel.searchSasac()
////        viewModel.addData()
//        mainView.collectionView.reloadData()
//    }
}

extension SearchViewController: SCVDelegate {
    func goToVC(index: Int, request: Bool, uid: String, nickname: String) {
        let nextVC = PopupViewController()
        if request {
            nextVC.setTitle(title: "스터디를 요청할게요!")
            nextVC.setSubtitle(subtitle: "상대방이 요청을 수락하면\n채팅창에서 대화를 나눌 수 있어요")
            nextVC.studyRequest()
        } else {
            nextVC.setTitle(title: "스터디를 수락할까요?")
            nextVC.setSubtitle(subtitle: "요청을 수락하면 채팅창에서 대화를 나눌 수 있어요")
            nextVC.studyAccept()
        }
        nextVC.uid = uid
        nextVC.nickname = nickname
        nextVC.modalPresentationStyle = .overFullScreen
        present(nextVC, animated: true)
    }
    
    func refrash() {
        viewModel.searchSasac()
    }
}
