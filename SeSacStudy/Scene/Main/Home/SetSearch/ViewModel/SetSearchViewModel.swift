//
//  SetSearchViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/19.
//

import Foundation

import RxSwift
import RxRelay

enum SearchSection: Int {
    case near = 0
    case study = 1
    
    var header: String {
        switch self {
        case .near:
            return "지금 주변에는"
        case .study:
            return "내가 하고 싶은"
        }
    }
}

final class SetSearchViewModel {
    
    var searchData: MatchSesac?
    var coordinate: Coordinate?
    
    var searchQueueCode = PublishRelay<SearchQueueStatusCode>()
    private let queueService = QueueAPIService()
    
    var list: Set<String> = []
    var nearList: [Study] = []
    var studyList: [Study] = []
    
    func fetchNear() {
        guard let searchData else { return }
        
        list = Set(searchData.fromRecommend)
        
        searchData.fromQueueDB.forEach {
            $0.studylist.forEach {
                list.insert($0)
            }
        }
        
        searchData.fromRecommend.forEach {
            list.remove($0)
            let study = Study(title: $0)
            study.recommend = true
            print(study.title)
            nearList.append(study)
        }
        
        list.forEach {
            let study = Study(title: $0)
            print(study.title)
            nearList.append(study)
        }
    }
    
    func searchStudy() {
        let studyList = studyList.count > 0 ? studyList.map{$0.title} : ["anything"]
        let idToken = UserDefaultsHelper.standard.idToken
        guard let coordinate else { return }
        queueService.searchStudy(idToken: idToken, lat: coordinate.lat, long: coordinate.long, studyList: studyList) { [self] statusCode in
            searchQueueCode.accept(SearchQueueStatusCode(rawValue: statusCode) ?? .UnknownError)
        }
    }
}
