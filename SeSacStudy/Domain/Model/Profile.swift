//
//  Profile.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import Foundation

struct Profile {
    var phoneNumber: String
    var nickname: String
    var birth: Date
    var email: String
    var gender: Gender
}

enum Gender: Int {
    case Man = 0
    case Woman = 1
    case Nothing = -1
}
