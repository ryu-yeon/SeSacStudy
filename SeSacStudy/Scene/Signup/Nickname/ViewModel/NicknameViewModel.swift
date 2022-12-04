//
//  NicknameViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/09.
//

import Foundation

import RxSwift
import RxRelay

final class NicknameViewModel {

    var profile: Profile?
    var vaild = BehaviorRelay(value: false)
    
    func isVaildNickname(nickname: String) {
        let nicknameRegEx = "^[가-힣a-zA-Z0-9]{1,10}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", nicknameRegEx)
        
        vaild.accept(predicate.evaluate(with: nickname))
        profile?.nickname = nickname
    }
}
