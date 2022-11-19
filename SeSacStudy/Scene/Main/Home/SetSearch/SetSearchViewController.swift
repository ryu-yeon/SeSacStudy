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

final class SetSearchViewController: BaseViewController {
    
    private let mainView = SetSearchView()
    let viewModel = SetSearchViewModel()
    private let disposeBag = DisposeBag()
    
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
        setBackButton()
        setKeyboard()
        
    }
    
    override func setNavigationBar() {
        //서치
        let width = UIScreen.main.bounds.width - 64
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: width, height: 0))
        searchBar.delegate = self
        searchBar.placeholder = "띄어쓰기로 복수 입력이 가능해요"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchBar)
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
        guard let text = searchBar.text else { return }
        
        let input = text.split(separator: " ").map{String($0)}
        
        viewModel.studyList.append(contentsOf: input)
        viewModel.fetchStudy()
    }
}
