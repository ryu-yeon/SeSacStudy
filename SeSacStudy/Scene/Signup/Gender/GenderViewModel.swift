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
    
    var profile: Profile?
    
    var data = PublishSubject<Int>()
    
    let firebaseAuthManager = FirebaseAuthManager()
    let apiService = APIService()
    
    func fetch() {
        data.onNext(profile?.gender ?? -1)
    }
}
