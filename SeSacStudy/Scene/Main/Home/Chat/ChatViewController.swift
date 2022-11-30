//
//  ChatViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/17.
//

import UIKit

import RxCocoa
import RxSwift

final class ChatViewController: BaseViewController {
    
    private let mainView = ChatView()
    let viewModel = ChatViewModel()
    private let disposeBag = DisposeBag()
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Chat>!
    
    var snapshot = NSDiffableDataSourceSnapshot<Int, Chat>()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.loadChat()
        
        viewModel.list
            .withUnretained(self)
            .bind { (vc, value) in
                vc.snapshot.appendItems(value.payload)
                vc.dataSource.apply(vc.snapshot)
            }
            .disposed(by: disposeBag)
        
        setRootButton()
        setNavigationBar()
        setChatView()
        setMenuButton()
        setCollectionView()
    }
    
    private func setChatView() {
        mainView.textView.rx.text
            .orEmpty
            .withUnretained(self)
            .bind { (vc, value) in
                let sendButtonImage = value.count > 0 ? UIImage(named: "send_act") : UIImage(named: "send_inact")
                vc.mainView.sendButton.setImage(sendButtonImage, for: .normal)
            }
            .disposed(by: disposeBag)
    }
    
    private func setSendButton() {
        mainView.sendButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
//                let input = vc.mainView.textView.text
                
            }
            .disposed(by: disposeBag)
    }
    
    override func setNavigationBar() {
        navigationItem.title = viewModel.yourNickname
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more_dot"), style: .plain, target: self, action: #selector(moreButtonClicked))
    }
    
    @objc private func moreButtonClicked() {
        mainView.view.isHidden = !mainView.view.isHidden
        mainView.stackView.isHidden = !mainView.stackView.isHidden
    }
    
    private func setMenuButton() {
        
    }
    
    private func setCollectionView() {
        
        mainView.collectionView.register(MyChatCollectionViewCell.self, forCellWithReuseIdentifier: MyChatCollectionViewCell.reusableIdentifier)
        mainView.collectionView.register(YourChatCollectionViewCell.self.self, forCellWithReuseIdentifier: YourChatCollectionViewCell.reusableIdentifier)
        
        mainView.collectionView.dataSource = dataSource
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            if itemIdentifier.from != self.viewModel.myID {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: YourChatCollectionViewCell.reusableIdentifier, for: indexPath) as? YourChatCollectionViewCell else { return UICollectionViewCell() }
                cell.chatLabel.text = itemIdentifier.chat
                
                return cell
            
            } else {
                
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyChatCollectionViewCell.reusableIdentifier, for: indexPath) as? MyChatCollectionViewCell else { return UICollectionViewCell() }
                cell.chatLabel.text = itemIdentifier.chat
                return cell
            }
        })
        
        snapshot.appendSections([0])
        snapshot.appendItems([Chat(_id: "61e3c18b9411a6190a19428b",
                                   to: "xGpE8KeXgMTnQtpR90fhdR4IVsO2",
                                   from: "NuK12cdVaDVcc9e4ctxsLMNCrHQ2",
                                   chat: "반갑습니다 :)",
                                   createdAt: "2022-11-16T06:55:54.784Z"),
                              Chat(_id: "61e3c128b9411a6190a19428b",
                                                         to: "xGpE8KeXgMTnQtpR90fhdR4IVsO2",
                                                         from: "Y4AuG3VuEPUa21S4I8vNLrLqwY63",
                                                         chat: "반갑습니다 :)",
                                                         createdAt: "2022-11-16T06:55:54.784Z")])
        dataSource.apply(snapshot)
        
    }
}
