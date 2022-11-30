//
//  Sesac.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/18.
//

import Foundation

class Sesac: Codable, Hashable {
    let uid: String
    let nick: String
    let lat: Double
    let long: Double
    let reputation: [Int]
    let studylist: [String]
    let reviews: [String]
    let gender: Int
    let type: Int
    let sesac: Int
    let background: Int
    
    init(uid: String, nick: String, lat: Double, long: Double, reputation: [Int], studylist: [String], reviews: [String], gender: Int, type: Int, sesac: Int, background: Int) {
        self.uid = uid
        self.nick = nick
        self.lat = lat
        self.long = long
        self.reputation = reputation
        self.studylist = studylist
        self.reviews = reviews
        self.gender = gender
        self.type = type
        self.sesac = sesac
        self.background = background
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uid)
    }
    
    static func == (lhs: Sesac, rhs: Sesac) -> Bool {
        lhs.uid == rhs.uid
    }
}
