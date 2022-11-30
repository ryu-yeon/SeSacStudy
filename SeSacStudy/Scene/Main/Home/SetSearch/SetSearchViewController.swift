//
//  SetSearchViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/17.
//

import UIKit

import RxCocoa
import RxSwift
import RxKeyboard
import Toast

final class SetSearchViewController: BaseViewController {
    
    private let mainView = SetSearchView()
    let viewModel = SetSearchViewModel()
    private let disposeBag = DisposeBag()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Study>!
    
    var snapshot = NSDiffableDataSourceSnapshot<Int, Study>()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setRootButton()
        setKeyboard()
        setSearchButton()
        
        viewModel.fetchNear()
        setCollectionView()
    }
    
    override func setNavigationBar() {
        let width = UIScreen.main.bounds.width - 64
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        searchBar.delegate = self
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
    }
    
    private func setSearchButton() {
        mainView.searchButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                
                let studyList = vc.viewModel.studyList.count > 0 ? vc.viewModel.studyList.map{$0.title} : ["anything"]
                
                
                let idToken = UserDefaultsHelper.standard.idToken
                vc.viewModel.apiService.searchStudy(idToken: idToken, lat: vc.viewModel.lat, long: vc.viewModel.long, studyList: studyList) { statusCode in
                    vc.checkStatusCode(statusCode)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func checkStatusCode(_ statusCode: Int) {
        
        switch statusCode {
        case 200:
            let nextVC = SearchViewController()
            nextVC.viewModel.lat = viewModel.lat
            nextVC.viewModel.long = viewModel.long
            viewModel.searchSasac { data in
                if let data {
                    DispatchQueue.main.async {
                        nextVC.viewModel.searchData = data
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                }
            }
            
            print("찾기 요청 성공🟢")
        case 201:
            self.mainView.makeToast("신고가 누적되어 이용하실 수 없습니다", duration: 1.0, position: .top)
            print("신고하기 3번이상 받은 유저🟡")
        case 203:
            self.mainView.makeToast("스터디 취소 패널티로, 1분동안 이용하실 수 없습니다", duration: 1.0, position: .top)
            print("스터디 취소 페널티 1단계🟡")
        case 204:
            self.mainView.makeToast("스터디 취소 패널티로, 2분동안 이용하실 수 없습니다", duration: 1.0, position: .top)
            print("스터디 취소 페널티 2단계🟡")
        case 205:
            self.mainView.makeToast("스터디 취소 패널티로, 3분동안 이용하실 수 없습니다", duration: 1.0, position: .top)
            print("스터디 취소 페널티 3단계🟡")
        case 401:
            viewModel.firebaseAuthManager.getIdToken { idToken in
                if let idToken {
                    let studyList = self.viewModel.studyList.count > 0 ? self.viewModel.studyList.map{$0.title} : ["anything"]
                    self.viewModel.apiService.searchStudy(idToken: idToken, lat: self.viewModel.lat, long: self.viewModel.long, studyList: studyList) { statusCode in
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
    
    private func setKeyboard() {
        RxKeyboard.instance.visibleHeight
                .drive(onNext: { [weak self] keyboardVisibleHeight in
                    guard let self = self else { return }
                    
                    UIView.animate(withDuration: 0) {
                        if keyboardVisibleHeight == 0 {
                            self.mainView.searchButton.snp.updateConstraints { make in
                                make.bottom.equalToSuperview().inset(50)
                            }
                        } else {
                            let totalHeight = keyboardVisibleHeight
                            self.mainView.searchButton.layer.cornerRadius = 0
                            self.mainView.searchButton.snp.updateConstraints { make in
                                make.horizontalEdges.equalToSuperview()
                                make.bottom.equalToSuperview().inset(totalHeight)
                            }
                        }
                        self.view.layoutIfNeeded()
                    }
                }).disposed(by: disposeBag)
    }
    
}

extension SetSearchViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {
            self.mainView.makeToast("최소 한 자 이상, 최대 8글자까지 작성 가능합니다", duration: 1.0, position: .top)
            return
        }
        
        let input = text.split(separator: " ").map{String($0)}
        
        input.forEach {
            if $0.count >= 1 && $0.count <= 8 {
                if viewModel.studyList.count >= 8 {
                    self.mainView.makeToast("스터디를 더 이상 추가할 수 없습니다", duration: 1.0, position: .top)
                } else {
                    
                    for i in viewModel.studyList {
                        if i.title == $0 {
                            self.mainView.makeToast("이미 등록된 스터디입니다.", duration: 1.0, position: .top)
                            return
                        }
                    }
                    
                    let study = Study(title: $0)
                    viewModel.studyList.append(study)
                }
            } else {
                self.mainView.makeToast("최소 한 자 이상, 최대 8글자까지 작성 가능합니다", duration: 1.0, position: .top)
            }
        }
        snapshot.appendItems(viewModel.studyList, toSection: 1)
        dataSource.apply(snapshot)
        
        searchBar.text = ""
        view.endEditing(true)
    }
}

extension SetSearchViewController {
    
    private func setCollectionView() {
        mainView.collectionView.register(StudyCollectionViewCell.self, forCellWithReuseIdentifier: StudyCollectionViewCell.reusableIdentifier)
        
        mainView.collectionView.dataSource = dataSource
        mainView.collectionView.delegate = self
        
        mainView.collectionView.register(
            BaseCollectionHeaderView.self,
          forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "BaseCollectionHeaderView")
        
        dataSource = UICollectionViewDiffableDataSource<Int, Study>(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StudyCollectionViewCell.reusableIdentifier, for: indexPath) as? StudyCollectionViewCell else { return UICollectionViewCell() }
            
            switch indexPath.section {
            case 0:
                cell.update()
                if itemIdentifier.recommend {
                    cell.contentView.layer.borderColor = UIColor.red.cgColor
                    cell.titleLabel.textColor = .red
                }
            case 1:
                cell.contentView.layer.borderColor = UIColor.brandGreen.cgColor
                cell.titleLabel.textColor = .brandGreen
                cell.xImageView.isHidden = false
            default: break
            }
            cell.titleLabel.text = itemIdentifier.title
            
            return cell
        })
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
          guard kind == UICollectionView.elementKindSectionHeader else {
            return nil
          }
          let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "BaseCollectionHeaderView",
            for: indexPath) as? BaseCollectionHeaderView
            view?.label.text = self.viewModel.sectionTitle[indexPath.section]
          return view
        }
        
        snapshot.appendSections([0, 1])
        snapshot.appendItems(viewModel.nearList, toSection: 0)
        snapshot.appendItems(viewModel.studyList, toSection: 1)
        dataSource.apply(snapshot)
    }
}

extension SetSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            
            for i in viewModel.studyList {
                if i.title == viewModel.nearList[indexPath.item].title {
                    self.mainView.makeToast("이미 등록된 스터디입니다.", duration: 1.0, position: .top)
                    return
                }
            }
            
            if viewModel.studyList.count >= 8 {
                self.mainView.makeToast("스터디를 더 이상 추가할 수 없습니다", duration: 1.0, position: .top)
            } else {
                let study = Study(title: viewModel.nearList[indexPath.item].title)
                viewModel.studyList.append(study)
                snapshot.appendItems(viewModel.studyList, toSection: 1)
                dataSource.apply(snapshot)
            }
        case 1:
            snapshot.deleteItems([viewModel.studyList[indexPath.item]])
            viewModel.studyList.remove(at: indexPath.item)
            dataSource.apply(snapshot)
        default: break
        }
    }
}
