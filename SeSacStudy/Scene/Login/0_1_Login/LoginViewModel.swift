//
//  LoginViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

final class LoginViewModel {
    
    let firebaseAuthManager = FirebaseAuthManager()
    
    var valid = PublishSubject<Bool>()
    var isValid = false
    var phoneNumber = ""
    
    func withHypen(number: String) {
        var stringWithHypen: String = number
        stringWithHypen = stringWithHypen.replacingOccurrences(of: "-", with: "")
        if stringWithHypen.count == 10  || stringWithHypen.count == 11 {
            stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
            stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.endIndex, offsetBy: -4))
        }
        phoneNumber = stringWithHypen
        isValidPhone(phoneNumber: phoneNumber)
    }
    
    func isValidPhone(phoneNumber: String) {
        let phoneRegex = "^01([0-9])-?([0-9]{3,4})-?([0-9]{4})$"
        let pred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        isValid = pred.evaluate(with: phoneNumber)
        fetch()
    }
    
    func fetch() {
        valid.onNext(isValid)
    }
}
