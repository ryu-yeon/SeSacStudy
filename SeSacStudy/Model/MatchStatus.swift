//
//  MatchStatus.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/17.
//

import Foundation

struct MatchStatus: Codable {
    var dodged: Int
    var matched: Int
    var reviewed : Int
    var matchedNick: String
    var matchedUid: String
}
