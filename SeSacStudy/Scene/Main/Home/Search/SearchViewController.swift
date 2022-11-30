//
//  SearchViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/17.
//

import UIKit

import RxCocoa
import RxSwift

final class SearchViewController: BaseViewController {
    
    private let mainView = SearchView()
    let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setRootButton()
        setCollectionView()
        
        dump(viewModel.searchData?.fromQueueDBRequested)
        
        
        mainView.collectionView.rx.willEndDragging
            .bind { (velocity, targetContentOffset) in
                let page = Int(targetContentOffset.pointee.x / self.mainView.frame.width)
                
                if page == 0 {
                    self.mainView.nearButton.setTitleColor(.brandGreen, for: .normal)
                    self.mainView.lineView.backgroundColor = .brandGreen
                    self.mainView.recieveButton.setTitleColor(.gray6, for: .normal)
                    self.mainView.lineView2.backgroundColor = .gray6
                } else {
                    self.mainView.nearButton.setTitleColor(.gray6, for: .normal)
                    self.mainView.lineView.backgroundColor = .gray6
                    self.mainView.recieveButton.setTitleColor(.brandGreen, for: .normal)
                    self.mainView.lineView2.backgroundColor = .brandGreen
                }
            }
            .disposed(by: disposeBag)
        
        mainView.nearButton.rx.tap
            .bind { _ in
                let index = IndexPath(item: 0, section: 0)
                let rect = self.mainView.collectionView.layoutAttributesForItem(at: index)?.frame
                self.mainView.collectionView.scrollRectToVisible(rect!, animated: true)
                self.mainView.nearButton.setTitleColor(.brandGreen, for: .normal)
                self.mainView.lineView.backgroundColor = .brandGreen
                self.mainView.recieveButton.setTitleColor(.gray6, for: .normal)
                self.mainView.lineView2.backgroundColor = .gray6
            }
            .disposed(by: disposeBag)
        
        mainView.recieveButton.rx.tap
            .bind { _ in
                let index = IndexPath(item: 1, section: 0)
                let rect = self.mainView.collectionView.layoutAttributesForItem(at: index)?.frame
                self.mainView.collectionView.scrollRectToVisible(rect!, animated: true)
                self.mainView.nearButton.setTitleColor(.gray6, for: .normal)
                self.mainView.lineView.backgroundColor = .gray6
                self.mainView.recieveButton.setTitleColor(.brandGreen, for: .normal)
                self.mainView.lineView2.backgroundColor = .brandGreen
            }
            .disposed(by: disposeBag)
        
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func setNavigationBar() {
        navigationItem.title = "새싹찾기"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "찾기중단", style: .plain, target: self, action: #selector(stopButonClicked))
    }
    
    @objc func stopButonClicked() {
        stopSearch()
        guard let viewControllerStack = self.navigationController?.viewControllers else { return }
        for viewController in viewControllerStack {
            self.navigationController?.popToViewController(viewController, animated: true)
        }
    }
    
    private func stopSearch() {
        let idToken = UserDefaultsHelper.standard.idToken
        viewModel.apiService.stopSearchStudy(idToken: idToken) { statusCode in
            self.checkStatusCode(statusCode)
        }
    }
    
    private func checkStatusCode(_ statusCode: Int) {
        
        switch statusCode {
        case 200:
            print("찾기 중단 성공🟢")
        case 201:
            print("매칭 상태🟠")
        case 401:
            viewModel.firebaseAuthManager.getIdToken { idToken in
                if let idToken {
                    self.viewModel.apiService.stopSearchStudy(idToken: idToken) { statusCode in
                        self.checkStatusCode(statusCode)
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
    
    private func setCollectionView() {
        
        mainView.collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.reusableIdentifier)
        mainView.collectionView.delegate = self
        mainView.collectionView.dataSource = self
    }
    
    func searchSasac() {
        let idToken = UserDefaultsHelper.standard.idToken
        viewModel.apiService.searchSesac(idToken: idToken, lat: viewModel.lat, long: viewModel.long) { data, statusCode in
            self.checkStatusCode2(statusCode, data: data)
        }
    }
    
    private func checkStatusCode2(_ statusCode: Int, data: MatchSesac?) {
        switch statusCode {
        case 200:
            if let data {
                viewModel.searchData = data
            }
            print("검색 성공🟢")
        case 401:
            viewModel.firebaseAuthManager.getIdToken { [weak self] idToken in
                if let idToken {
                    self?.viewModel.apiService.searchSesac(idToken: idToken, lat: self?.viewModel.lat ?? 0, long: self?.viewModel.long ?? 0) { data, statusCode in
                        self?.checkStatusCode2(statusCode, data: data)
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
    
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.reusableIdentifier, for: indexPath) as? SearchCollectionViewCell else { return UICollectionViewCell() }
        
        guard let searchData = viewModel.searchData else { return cell }
        
        switch indexPath.item {
        case 0:
            if searchData.fromQueueDB.isEmpty {
                cell.changeButton.isHidden = false
                cell.refreshButton.isHidden = false
                cell.emptyImageView.isHidden = false
                cell.tableView.isHidden = true
            } else {
                cell.changeButton.isHidden = true
                cell.refreshButton.isHidden = true
                cell.emptyImageView.isHidden = true
                cell.tableView.isHidden = false
                cell.sesacList = searchData.fromQueueDB
                cell.isClicked = [Bool](repeating: false, count: searchData.fromQueueDB.count)
                cell.buttonColor = .errorColor
                cell.text = "요청하기"
                cell.delegate = self
                cell.request = true
            }
        case 1:
            if searchData.fromQueueDBRequested.isEmpty {
                cell.changeButton.isHidden = false
                cell.refreshButton.isHidden = false
                cell.emptyImageView.isHidden = false
                cell.tableView.isHidden = true
            } else {
                cell.changeButton.isHidden = true
                cell.refreshButton.isHidden = true
                cell.emptyImageView.isHidden = true
                cell.tableView.isHidden = false
                cell.sesacList = searchData.fromQueueDBRequested
                cell.isClicked = [Bool](repeating: false, count: searchData.fromQueueDBRequested.count)
                cell.buttonColor = .successColor
                cell.text = "수락하기"
                cell.delegate = self
                cell.request = false
            }
            
        default:
            break
        }
        
        cell.changeButton.addTarget(self, action: #selector(changeButtonClicked), for: .touchUpInside)
        cell.refreshButton.addTarget(self, action: #selector(refreshButtonClicked), for: .touchUpInside)
        
        return cell
    }
    
    @objc func changeButtonClicked() {
        let nextVC = SetSearchViewController()
        stopSearch()
        searchSasac()
        nextVC.viewModel.searchData = viewModel.searchData
        nextVC.viewModel.lat = viewModel.lat
        nextVC.viewModel.long = viewModel.long
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func refreshButtonClicked() {
        searchSasac()
        mainView.collectionView.reloadData()
    }
}

extension SearchViewController: SCVDelegate {
    func goToVC(index: Int, request: Bool, uid: String) {
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
        nextVC.modalPresentationStyle = .overFullScreen
        present(nextVC, animated: true)
    }
}
