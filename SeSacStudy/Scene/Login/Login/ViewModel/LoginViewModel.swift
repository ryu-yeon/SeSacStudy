//
//  LoginViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/08.
//

import Foundation

import RxSwift
import RxRelay

final class LoginViewModel {
    
    var valid = BehaviorRelay(value: false)
    var text = PublishRelay<String>()
    var firebaseCode = PublishRelay<FirebaseAuthStatusCode>()
    
    let firebaseAuthManager = FirebaseAuthManager()
    var phoneNumber = ""
    
    func withHypen(number: String) {
        var stringWithHypen: String = number
        stringWithHypen = stringWithHypen.replacingOccurrences(of: "-", with: "")
        if stringWithHypen.count == 10  || stringWithHypen.count == 11 {
            stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
            stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.endIndex, offsetBy: -4))
        }
        phoneNumber = stringWithHypen
        text.accept(stringWithHypen)
        isValidPhone(phoneNumber: stringWithHypen)
    }
    
    func isValidPhone(phoneNumber: String) {
        let phoneRegex = "^01([0-9])-?([0-9]{3,4})-?([0-9]{4})$"
        let pred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        valid.accept(pred.evaluate(with: phoneNumber))
    }
    
    func requestAuth() {
        firebaseAuthManager.sendSMS(phoneNumber: phoneNumber) { error, statusCode in
            self.firebaseCode.accept(FirebaseAuthStatusCode(rawValue: statusCode) ?? .UnknownError)
        }
    }
}
