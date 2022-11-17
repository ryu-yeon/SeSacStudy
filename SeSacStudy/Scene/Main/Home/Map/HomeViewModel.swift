//
//  HomeViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import Foundation

final class HomeViewModel {
    
    let user = UserDefaultsHelper.standard.loadUser()!
    let apiService = APIService()
    let firebaseAuthManager = FirebaseAuthManager()
    
    var matchStatus: MatchStatus?
    
    private func checkMyStatus() {
        let idToken = UserDefaultsHelper.standard.idToken
        apiService.getMyState(idToken: idToken) { [weak self] (data, statusCode) in
            self?.checkStatusCode(statusCode, data: data)
        }
    }
    
    private func checkStatusCode(_ statusCode: Int, data: MatchStatus?) {
        switch statusCode {
        case 200:
            guard let data else { return }
            matchStatus = data
            print("매칭 상태 확인 성공🟢")
        case 201:
            print("일반 상태🟠")
        case 401:
            firebaseAuthManager.getIdToken { [weak self] idToken in
                if let idToken {
                    self?.apiService.getMyState(idToken: idToken) { (data, statusCode)  in
                        self?.checkStatusCode(statusCode, data: data)
                    }
                }
            }
            print("Firebase Token Error🔴")
        case 406:
            print("미가입 유저😀")
        case 500:
            print("Server Error🔴")
        case 501:
            print("Client Error🔴")
        default:
            break
        }
    }
}
