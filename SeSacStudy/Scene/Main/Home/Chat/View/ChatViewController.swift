//
//  ChatViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/17.
//

import UIKit

import RxCocoa
import RxSwift
import RxKeyboard

final class ChatViewController: BaseViewController {
    
    private let mainView = ChatView()
    let viewModel = ChatViewModel()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetch()
        
        viewModel.loadChat { [weak self] in
            self?.setLabel()
            self?.viewModel.fetch()
            self?.reloadTableView()
            self?.viewModel.socketManager.establishConnection()
        }
        
        setRootButton()
        setNavigationBar()
        setChatView()
        setMenuButton()
        setTableView()
        setSendButton()
        setKeyboard()
        setTapGesture()
        setChat()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.socketManager.closeConnection()
    }
    
    private func setTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap))
        tap.cancelsTouchesInView = false
        mainView.tableView.addGestureRecognizer(tap)
    }
    
    @objc func tap() {
        view.endEditing(true)
    }
    
    private func setKeyboard() {
        RxKeyboard.instance.visibleHeight
                .drive(onNext: { [weak self] keyboardVisibleHeight in
                    guard let self = self else { return }
                    
                    UIView.animate(withDuration: 0) {
                        self.mainView.updateTextContainer(keyboardVisibleHeight: keyboardVisibleHeight)
                        self.view.layoutIfNeeded()
                    }
                }).disposed(by: disposeBag)
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
    
    private func setLabel() {
        mainView.dateLabel.text = viewModel.calaculatedDate()
        mainView.titleLabel.text = "\(viewModel.yourNickname)님과 매칭되었습니다."
    }
    
    private func checkStatusCode(_ statusCode: Int, chat: String, data: Chat?) {
        switch statusCode {
        case 200:
            if let data {
                viewModel.chatRepository.saveChat(data: data)
                reloadTableView()
            }
            print("채팅 전송 성공🟢")
        case 401:
            FirebaseTokenManager.shared.getIdToken { idToken in
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
        
        mainView.reviewButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                nextVC.modalPresentationStyle = .overFullScreen
                nextVC.setTitle(title: "리뷰 등록")
                nextVC.setSubtitle(subtitle: "\(vc.viewModel.yourNickname)님과의 스터디는 어떠셨나요?")
                nextVC.setSubtitleColor(.brandGreen)
                nextVC.setOnlyOkButton()
                nextVC.uid = vc.viewModel.yourID
                nextVC.registerReview()
                vc.present(nextVC, animated: true)
            }
            .disposed(by: disposeBag)
    }
    
    private func setTableView() {
        mainView.tableView.delegate = self
        mainView.tableView.dataSource = self
    }
    
    private func setChat() {
        NotificationCenter.default.addObserver(self, selector: #selector(getMessage(notification:)), name: NSNotification.Name("getMessage"), object: nil)
    }
    
    @objc func getMessage(notification: NSNotification) {

        let id = notification.userInfo!["id"] as! String
        let chat = notification.userInfo!["chat"] as! String
        let createdAt = notification.userInfo!["createdAt"] as! String
        let from = notification.userInfo!["from"] as! String
        let to = notification.userInfo!["to"] as! String

        let data = Chat(_id: id, to: to, from: from, chat: chat, createdAt: createdAt)

        viewModel.chatRepository.saveChat(data: data)
        reloadTableView()
    }
    
    private func reloadTableView() {
        mainView.tableView.reloadData()
        mainView.tableView.scrollToRow(at: IndexPath(row: viewModel.chatData.count - 1, section: 0), at: .bottom, animated: false)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.chatData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let chatList = viewModel.chatData else { return UITableViewCell() }

        if chatList[indexPath.row].from == viewModel.myID {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MyChatTableViewCell.reusableIdentifier, for: indexPath) as? MyChatTableViewCell else { return UITableViewCell()}
            
            cell.chatLabel.text = chatList[indexPath.row].chat
            cell.dateLabel.text = viewModel.calculatedChatDate(creatAt: chatList[indexPath.row].createdAt)
            return cell
            
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: YourChatTableViewCell.reusableIdentifier, for: indexPath) as? YourChatTableViewCell else { return UITableViewCell()}
            cell.chatLabel.text = chatList[indexPath.row].chat
            cell.dateLabel.text = viewModel.calculatedChatDate(creatAt: chatList[indexPath.row].createdAt)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
