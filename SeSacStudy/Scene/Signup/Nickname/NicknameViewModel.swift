//
//  NicknameViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/09.
//

import Foundation

import RxCocoa
import RxSwift

final class NicknameViewModel {

    var profile: Profile?
    var vaild = PublishSubject<Bool>()
    var isVaild = false
    
    func isVaildNickname(nickname: String) {
        let nicknameRegEx = "^[가-힣a-zA-Z0-9]{1,10}$"
        let predicate = NSPredicate(format:"SELF MATCHES %@", nicknameRegEx)
        
        isVaild = predicate.evaluate(with: nickname)
        fetch()
    }
    
    func fetch() {
        vaild.onNext(isVaild)
    }
}
