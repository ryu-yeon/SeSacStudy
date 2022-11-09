//
//  BirthViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/09.
//

import Foundation

import RxCocoa
import RxSwift

final class BirthViewModel {
    
    let dateFormatter = DateFormatter()
    var date = BehaviorSubject(value: Date())
    var vaild = PublishSubject<Bool>()
    var year = ""
    var mouth = ""
    var day = ""
    var isVaild = false
    
    func isVaildDate(date: Date) {
        let age = Calendar.current.dateComponents([.year], from: date, to: Date()).year ?? 0
        if age >= 17 {
            isVaild = true
        } else {
            isVaild = false
        }
        self.date.onNext(date)
        fetch()
    }
    
    func fetch() {
        vaild.onNext(isVaild)
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
