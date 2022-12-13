//
//  ChatRepository.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/08.
//

import Foundation

import RealmSwift

final class ChatRepository {
    
    let localRealm = try! Realm()
    
    func saveChat(data: Chat) {
        do {
            try localRealm.write {
                let chat = ChatRealm(_id: data._id, to: data.to, from: data.from, chat: data.chat, createdAt: data.createdAt)
                localRealm.add(chat)
            }
        } catch {
            print("실패🔴🔴🔴", #function)
        }
    }
    
    func fetchChat(yourID: String) -> Results<ChatRealm> {
        let predicateQuery = NSPredicate(format: "from == %@ OR to == %@", yourID, yourID)
        return localRealm.objects(ChatRealm.self).filter(predicateQuery).sorted(byKeyPath: "createdAt", ascending: true)
    }
}
