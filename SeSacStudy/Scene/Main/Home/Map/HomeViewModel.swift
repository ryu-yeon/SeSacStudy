//
//  HomeViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import Foundation

import RxCocoa
import RxSwift

final class HomeViewModel {
    
    var statusData = PublishSubject<MatchStatus?>()
    var sesacData = PublishSubject<MatchSesac>()
    
    let user = UserDefaultsHelper.standard.loadUser()!
    let apiService = APIService()
    let firebaseAuthManager = FirebaseAuthManager()
    
    var matchStatus: MatchStatus?
    var matchSesac: MatchSesac?
    
    var lat: Double?
    var long: Double?
    
    func checkMyStatus() {
        let idToken = UserDefaultsHelper.standard.idToken
        apiService.getMyState(idToken: idToken) { (data, statusCode) in
            self.checkStatusCode(statusCode, data: data)
        }
    }
    
    private func checkStatusCode(_ statusCode: Int, data: MatchStatus?) {
        switch statusCode {
        case 200:
            guard let data else { return }
            print(data)
            matchStatus = data
            statusData.onNext(matchStatus)
            print("매칭 상태 확인 성공🟢")
        case 201:
            matchStatus = nil
            statusData.onNext(matchStatus)
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
    
    func searchSasac(lat: Double, long: Double) {
        let idToken = UserDefaultsHelper.standard.idToken
        self.lat = lat
        self.long = long
            apiService.searchSesac(idToken: idToken, lat: lat, long: long) { data, statusCode in
                    self.checkStatusCode2(statusCode, data: data)
        }
    }
    
    func checkStatusCode2(_ statusCode: Int, data: MatchSesac?) {
        switch statusCode {
        case 200:
            if let data {
                matchSesac = data
                sesacData.onNext(data)
            }
            print("검색 성공🟢")
        case 401:
            firebaseAuthManager.getIdToken { [weak self] idToken in
                if let idToken {
                    self?.apiService.searchSesac(idToken: idToken, lat: self?.lat ?? 0, long: self?.long ?? 0) { data, statusCode in
                        self?.checkStatusCode2(statusCode, data: data)
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
