//
//  EmailViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import Foundation

import RxCocoa
import RxSwift

final class EmailViewModel {
    
    var vaild = PublishSubject<Bool>()
    var isVaild = false
    
    func isVaildEmail(email: String) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        isVaild = predicate.evaluate(with: email)
        fetch()
    }
    
    func fetch() {
        vaild.onNext(isVaild)
    }
}
