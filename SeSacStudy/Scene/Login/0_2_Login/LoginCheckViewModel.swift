//
//  LoginCheckViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

class LoginCheckViewModel {
    
    var isValid = false
    var phoneNumber = ""
    var code = ""
    
    let firebaseAuthManager = FirebaseAuthManager()
    
    func isValidNumber() {
        let phoneRegex = "^[0-9]{6}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        isValid = pred.evaluate(with: code)
    }
}
