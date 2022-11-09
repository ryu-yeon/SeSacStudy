//
//  GenderViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import Foundation

import RxCocoa
import RxSwift

final class GenderViewModel {
    
    var gender = -1
    
    var data = PublishSubject<Int>()
    
    func fetch() {
        data.onNext(gender)
    }
}
