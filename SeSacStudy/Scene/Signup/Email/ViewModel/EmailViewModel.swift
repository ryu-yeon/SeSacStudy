//
//  EmailViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import Foundation

import RxSwift
import RxRelay

final class EmailViewModel {
    
    var vaild = BehaviorRelay(value: false)
    var profile: Profile?
    
    func isVaildEmail(email: String) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        vaild.accept(predicate.evaluate(with: email))
        profile?.email = email
    }
}
