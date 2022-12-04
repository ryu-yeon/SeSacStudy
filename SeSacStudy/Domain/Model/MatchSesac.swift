//
//  MatchSesac.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/18.
//

import Foundation

struct MatchSesac: Codable {
    let fromQueueDB: [Sesac]
    let fromQueueDBRequested: [Sesac]
    let fromRecommend: [String]
}
