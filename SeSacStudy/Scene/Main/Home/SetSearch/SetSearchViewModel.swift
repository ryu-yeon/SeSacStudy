//
//  SetSearchViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/19.
//

import Foundation

import RxCocoa
import RxSwift

final class SetSearchViewModel {
    
    var searchData: MatchSesac!
    
    var studyData = PublishSubject<[String]>()
    
    var studyList: [String] = []
    
    func fetchStudy() {
        studyData.onNext(studyList)
    }
}
