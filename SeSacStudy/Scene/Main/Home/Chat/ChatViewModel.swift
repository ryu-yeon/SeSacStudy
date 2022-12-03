//
//  ChatViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/01.
//

import Foundation

import RxCocoa
import RxSwift

final class ChatViewModel {
    
    let chatService = ChatAPIService()
    
    let myID = UserDefaultsHelper.standard.loadUser()?.uid
    
    var yourID = ""
    var yourNickname = ""

    var matchedNick: String?
    var matchedUid: String?
    
    lazy var socketManager = SocketIOMananger(myUID: UserDefaultsHelper.standard.loadUser()?.uid ?? "")
    
    var chatList: ChatList?
    
    var list = PublishSubject<ChatList>()
    
    func loadChat() {
        let idToken = UserDefaultsHelper.standard.idToken
        chatService.loadChatList(idToken: idToken, from: yourID, lastchatDate: "2022-11-16T06:55:54.784Z") { data, statusCode in
            self.checkStatusCode(statusCode, data: data)
        }
    }
    
    private func checkStatusCode(_ statusCode: Int, data: ChatList?) {
        switch statusCode {
        case 200:
            guard let data else { return }
            chatList = data
            list.onNext(chatList!)
            print("매칭 상태 확인 성공🟢")
        case 401:
            FireBaseTokenManager.shared.getIdToken { [weak self] idToken in
                self?.chatService.loadChatList(idToken: idToken, from: self?.yourID ?? "", lastchatDate: "2022-11-16T06:55:54.784Z") { data, statusCode in
                    self?.checkStatusCode(statusCode, data: data)
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
