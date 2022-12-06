//
//  GenderViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import Foundation

import RxSwift
import RxRelay

final class GenderViewModel {
    
    var profile: Profile?
    
    var gender = BehaviorRelay(value: Gender.Nothing)
    var signupCode = PublishRelay<UserStatusCode>()
    
    let userService = UserAPIService()

    func signup() {
        FirebaseTokenManager.shared.getIdToken { [self] idToken in
            userService.signup(idToken: idToken, profile: profile!) { [self] statusCode in
                signupCode.accept(UserStatusCode(rawValue: statusCode) ?? .UnknownError)
            }
        }
    }
}
