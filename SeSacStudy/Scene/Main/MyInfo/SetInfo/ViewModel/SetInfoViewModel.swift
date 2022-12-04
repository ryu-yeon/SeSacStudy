//
//  SetInfoViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/14.
//

import Foundation

import RxSwift
import RxRelay

final class SetInfoViewModel {
    
    var user = UserDefaultsHelper.standard.loadUser()!
    
    var isClicked = false
    
    var count: CGFloat = 1
    var comment = ""
    
    let apiService = APIService()
    
    let userService = UserAPIService()
    
    let firebaseAuthManager = FirebaseAuthManager()
    
    var userStatusCode = PublishRelay<UserStatusCode>()
    
    var list = ["내 성별", "자주하는 스터디", "내 번호 검색 허용", "상대방 연령대"]
    
    func updateMyData() {
        let idToken = UserDefaultsHelper.standard.idToken
        userService.updateMyPage(user: user, idToken: idToken) { statusCode in
            guard let userStatusCode = UserStatusCode(rawValue: statusCode) else { return }
            self.userStatusCode.accept(userStatusCode)
        }
    }
}
