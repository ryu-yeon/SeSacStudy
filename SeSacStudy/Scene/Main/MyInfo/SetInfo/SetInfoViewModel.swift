//
//  SetInfoViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/14.
//

import Foundation

final class SetInfoViewModel {
    
    var user = UserDefaultsHelper.standard.loadUser()!
    
    let apiService = APIService()
    let firebaseAuthManager = FirebaseAuthManager()
    
    var list = ["내 성별", "자주하는 스터디", "내 번호 검색 허용", "상대방 연령대"]
}
