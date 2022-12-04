//
//  Chat.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/01.
//

import Foundation

final class Chat: Codable, Hashable {
    let _id: String
    let to: String
    let from: String
    let chat: String
    let createdAt: String
    
    init(_id: String, to: String, from: String, chat: String, createdAt: String) {
        self._id = _id
        self.to = to
        self.from = from
        self.chat = chat
        self.createdAt = createdAt
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_id)
    }
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        lhs._id == rhs._id
    }
}
