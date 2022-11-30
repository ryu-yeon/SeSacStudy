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
    
    var lat: Double!
    var long: Double!
    
    var nearList: [Study] = []
    
    var list: Set<String> = []
    
    var studyList: [Study] = []
    
    let sectionTitle = ["지금 주변에는", "내가 하고 싶은"]
    
    let apiService = APIService()
    
    let firebaseAuthManager = FirebaseAuthManager()
    
    func fetchNear() {
        
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
    
    func searchSasac(handler: @escaping (MatchSesac?) -> ()) {
        let idToken = UserDefaultsHelper.standard.idToken
        apiService.searchSesac(idToken: idToken, lat:lat, long: long) { data, statusCode in
            handler(data)
        }
    }
}
