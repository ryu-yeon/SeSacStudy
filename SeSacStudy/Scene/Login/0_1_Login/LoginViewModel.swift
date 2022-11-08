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
    
    var isValid = false
    
    func isValidPhone(number: String) -> Bool {
        let phoneRegex = "^01([0-9])-?([0-9]{3,4})-?([0-9]{4})$"
        let pred = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return pred.evaluate(with: number)
    }
    
    func withHypen(number: String) -> String {
        var stringWithHypen: String = number
        stringWithHypen = stringWithHypen.replacingOccurrences(of: "-", with: "")
        if stringWithHypen.count == 10  || stringWithHypen.count == 11 {
            stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
            stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.endIndex, offsetBy: -4))
        }
        return stringWithHypen
    }
}
