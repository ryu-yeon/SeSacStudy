//
//  BirthViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/09.
//

import Foundation

import RxSwift
import RxRelay

final class BirthViewModel {
    
    private let dateFormatter = DateFormatter()
    var date = BehaviorSubject(value: Date())
    var vaild = BehaviorRelay(value: false)
    var year = ""
    var mouth = ""
    var day = ""
    var profile: Profile?
    
    func isVaildDate(date: Date) {
        let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
        if age >= 17 {
            vaild.accept(true)
        } else {
            vaild.accept(false)
        }
        self.date.onNext(date)
    }
    
    func dateformat(date: Date) {
        dateFormatter.dateFormat = "YYYY"
        year = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "M"
        mouth = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "d"
        day = dateFormatter.string(from: date)
    }
}
