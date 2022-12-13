//
//  ChatRealm.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/08.
//

import Foundation

import RealmSwift

final class ChatRealm: Object {
    @Persisted var _id: String
    @Persisted var to: String
    @Persisted var from: String
    @Persisted var chat: String
    @Persisted var createdAt: String
    
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(_id: String, to: String, from: String, chat: String, createdAt: String) {
        self.init()
        self._id = _id
        self.to = to
        self.from = from
        self.chat = chat
        self.createdAt = createdAt
    }
}
