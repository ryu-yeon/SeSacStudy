//
//  SplashViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import Foundation

import RxSwift
import RxRelay

final class SplashViewModel {
    
    let userService = UserAPIService()
    
    let statusCode = PublishRelay<UserStatusCode>()
    
    var user: User?
    
    func checkUser(complitionHander: @escaping () -> Void) {
        
        if UserDefaultsHelper.standard.start {
            FirebaseTokenManager.shared.getIdToken { [weak self] idToken in
                self?.userService.login(idToken: idToken) { user, statusCode in
                    guard let userStatusCode = UserStatusCode(rawValue: statusCode) else { return }
                    self?.user = user
                    self?.statusCode.accept(userStatusCode)
                }
            }
        } else {
            complitionHander()
        }
    }
}

