//
//  User.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import Foundation

struct User: Codable {
    let uid: String
    let phoneNumber: String
    let email: String
    var FCMtoken: String
    let nick: String
    let birth: String
    var gender: Int
    var study: String
    var comment: [String]
    var reputation: [Int]
    var sesac: Int
    var sesacCollection: [Int]
    var background: Int
    var purchaseToken: [String]
    var transactionId: [String]
    var reviewedBefore: [String]
    var reportedNum: Int
    var reportedUser: [String]
    var dodgepenalty: Int
    var dodgeNum: Int
    var ageMin: Int
    var ageMax: Int
    var searchable: Int
    var createdAt: String
}
