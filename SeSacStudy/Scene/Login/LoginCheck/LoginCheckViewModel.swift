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
    var profile = Profile(phoneNumber: "", nickname: "", birth: Date(), email: "", gender: -1)
    var vaild = PublishSubject<Bool>()
    var timer: Disposable?
    
    let firebaseAuthManager = FirebaseAuthManager()
    let apiService = APIService()
    
    func isValidNumber() {
        let phoneRegex = "^[0-9]{6}$"
        let pred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        isValid = pred.evaluate(with: code)
        vaild.onNext(isValid)
    }
    
    func getPhoneNumber() {
        var phoneData = phoneNumber.replacingOccurrences(of: "-", with: "")
        phoneData.remove(at: phoneData.index(phoneData.startIndex, offsetBy: 0))
        profile.phoneNumber = "+82\(phoneData)"
    }
}
