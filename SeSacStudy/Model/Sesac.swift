//
//  Sesac.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/18.
//

import Foundation

struct Sesac: Codable {
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
}
