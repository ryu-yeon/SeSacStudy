//
//  ChatViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/01.
//

import Foundation

import RealmSwift

final class ChatViewModel {
    
    let chatService = ChatAPIService()
    let chatRepository = ChatRepository()
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        return formatter
    }()
    
    var isoDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.insert(.withFractionalSeconds)
        return formatter
    }()
    
    var chatData: Results<ChatRealm>!
    let myID = UserDefaultsHelper.standard.loadUser()?.uid
    var yourID = ""
    var yourNickname = ""
    var lastchatDate = "2000-01-01T00:00:00.000Z"
    
    lazy var socketManager = SocketIOMananger(myUID: UserDefaultsHelper.standard.loadUser()?.uid ?? "")

    func fetch() {
        chatData = chatRepository.fetchChat(yourID: yourID)
        lastchatDate = chatData.last?.createdAt ?? "2000-01-01T00:00:00.000Z"
    }
    
    func loadChat(complitionHandler: @escaping () -> Void) {
        let idToken = UserDefaultsHelper.standard.idToken
        chatService.loadChatList(idToken: idToken, from: yourID, lastchatDate: lastchatDate) { data, statusCode in
            self.checkStatusCode(statusCode, data: data)
            complitionHandler()
        }
    }
    
    private func checkStatusCode(_ statusCode: Int, data: ChatList?) {
        switch statusCode {
        case 200:
            guard let data else { return }
            data.payload.forEach {
                chatRepository.saveChat(data: $0)
            }
            print("매칭 상태 확인 성공🟢")
        case 401:
            FirebaseTokenManager.shared.getIdToken { [weak self] idToken in
                self?.chatService.loadChatList(idToken: idToken, from: self?.yourID ?? "", lastchatDate: self?.lastchatDate ?? "") { data, statusCode in
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
    
    func calaculatedDate() -> String {
        dateFormatter.dateFormat = "M월 d일 EEEE"
        if let createdAt = chatData.last?.createdAt {
            let date = isoDateFormatter.date(from: createdAt) ?? Date()
            return dateFormatter.string(from: date)
        } else {
            return dateFormatter.string(from: Date())
        }
    }
    
    func calculatedChatDate(creatAt: String) -> String {
        let date = isoDateFormatter.date(from: creatAt) ?? Date()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}
