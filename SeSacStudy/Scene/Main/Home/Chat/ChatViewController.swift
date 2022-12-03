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
                vc.mainView.tableView.reloadData()
                vc.mainView.tableView.scrollToRow(at: IndexPath(row: (vc.viewModel.chatList?.payload.count ?? 1) - 1, section: 0), at: .bottom, animated: false)

                vc.viewModel.socketManager.establishConnection()
            }
            .disposed(by: disposeBag)
        
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
        
        setRootButton()
        setNavigationBar()
        setChatView()
        setMenuButton()
        setTableView()
        setSendButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.socketManager.closeConnection()
    }
    
    @objc func getMessage(notification: NSNotification) {
            
        let id = notification.userInfo!["id"] as! String
        let chat = notification.userInfo!["chat"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
        let from = notification.userInfo!["from"] as! String
        let to = notification.userInfo!["to"] as! String
        
        let data = Chat(_id: id, to: to, from: from, chat: chat, createdAt: createdAt)
        
        viewModel.chatList?.payload.append(data)
        mainView.tableView.reloadData()
        mainView.tableView.scrollToRow(at: IndexPath(row: (viewModel.chatList?.payload.count ?? 1) - 1, section: 0), at: .bottom, animated: false)
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
                let chat = vc.mainView.textView.text ?? ""
                let idToken = UserDefaultsHelper.standard.idToken
                vc.viewModel.chatService.sendChat(idToken: idToken, to: vc.viewModel.yourID, chat: chat) { data, statusCode in
                    vc.checkStatusCode(statusCode, chat: chat, data: data)
                }
                vc.mainView.textView.text = ""
            }
            .disposed(by: disposeBag)
    }
    
    private func checkStatusCode(_ statusCode: Int, chat: String, data: Chat?) {
        switch statusCode {
        case 200:
            if let data {
                viewModel.chatList?.payload.append(data)
                viewModel.list.onNext(viewModel.chatList!)
            }
            print("채팅 전송 성공🟢")
        case 401:
            FireBaseTokenManager.shared.getIdToken { idToken in
                self.viewModel.chatService.sendChat(idToken: idToken, to: self.viewModel.yourID, chat: chat) { data, statusCode in
                    self.checkStatusCode(statusCode, chat: chat, data: data)
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
        navigationItem.title = viewModel.yourNickname
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "more_dot"), style: .plain, target: self, action: #selector(moreButtonClicked))
    }
    
    @objc private func moreButtonClicked() {
        mainView.view.isHidden = !mainView.view.isHidden
        mainView.stackView.isHidden = !mainView.stackView.isHidden
    }
    
    private func setMenuButton() {
        let nextVC = PopupViewController()
        mainView.cancleButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                nextVC.modalPresentationStyle = .overFullScreen
                nextVC.setTitle(title: "스터디를 취소하겠습니까?")
                nextVC.setSubtitle(subtitle: "스터디를 취소하시면 패널티가 부과됩니다")
                nextVC.uid = vc.viewModel.yourID
                nextVC.cancleStudy()
                vc.present(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setTableView() {
        
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
        
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chatList?.payload.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let chatList = viewModel.chatList?.payload else { return UITableViewCell() }
        if chatList[indexPath.row].from == viewModel.myID {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.reusableIdentifier, for: indexPath) as? MyChatTableViewCell else { return UITableViewCell()}
            
            cell.chatLabel.text = chatList[indexPath.row].chat
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: YourChatTableViewCell.reusableIdentifier, for: indexPath) as? YourChatTableViewCell else { return UITableViewCell()}
            cell.chatLabel.text = chatList[indexPath.row].chat
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
