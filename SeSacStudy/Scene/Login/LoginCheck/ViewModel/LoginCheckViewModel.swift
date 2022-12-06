//
//  LoginCheckViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/08.
//

import Foundation

import RxSwift
import RxRelay

class LoginCheckViewModel {
    
    var vaild = BehaviorRelay(value: false)
    var firebaseCode = PublishRelay<FirebaseAuthStatusCode>()
    var loginCode = PublishRelay<UserStatusCode>()
    var timer: Disposable?
    
    var user: User?
    var phoneNumber = ""
    var code = ""
    var profile = Profile(phoneNumber: "", nickname: "", birth: Date(), email: "", gender: .Nothing)
    
    private let firebaseAuthManager = FirebaseAuthManager()
    private let userService = UserAPIService()
    
    func isValidNumber() {
        let phoneRegex = "^[0-9]{6}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        vaild.accept(pred.evaluate(with: code))
    }
    
    func getPhoneNumber() {
        var phoneData = phoneNumber.replacingOccurrences(of: "-", with: "")
        phoneData.remove(at: phoneData.index(phoneData.startIndex, offsetBy: 0))
        profile.phoneNumber = "+82\(phoneData)"
    }
    
    func requestAuth() {
        firebaseAuthManager.sendSMS(phoneNumber: phoneNumber) { error, statusCode in
            self.firebaseCode.accept(FirebaseAuthStatusCode(rawValue: statusCode) ?? .UnknownError)
        }
    }
    
    func checkAuth() -> Error? {
        var error: Error?
        firebaseAuthManager.checkCode(code: code) { er in
            error = er
        }
        return error
    }
    
    func checkUser() {
        getPhoneNumber()
        FirebaseTokenManager.shared.getIdToken { [weak self] idToken in
            self?.userService.login(idToken: idToken) { user, statusCode in
                self?.user = user
                self?.loginCode.accept(UserStatusCode(rawValue: statusCode) ?? .UnknownError)
            }
        }
    }
}
