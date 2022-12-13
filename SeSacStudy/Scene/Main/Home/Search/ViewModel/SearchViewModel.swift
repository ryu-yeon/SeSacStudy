//
//  SearchViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/24.
//

import Foundation

import RxSwift
import RxRelay

enum Page: Int {
    case nearSesac = 0
    case request = 1
}

final class SearchViewModel {
    
    var page = BehaviorRelay(value: Page.nearSesac)
    var data = PublishSubject<[[Sesac]]>()
    var myStatus = PublishRelay<MatchStatus?>()
    
    private let queueService = QueueAPIService()
    
    var searchData: MatchSesac?
    
    lazy var coordinate = UserDefaultsHelper.standard.loadCoordinate()
    
    func fetchData() {
        if let searchData {
            data.onNext([searchData.fromQueueDB, searchData.fromQueueDBRequested])
        } else {
            data.onNext([[],[]])
        }
    }

    func stopSearch() {
        let idToken = UserDefaultsHelper.standard.idToken
        queueService.stopSearchStudy(idToken: idToken) { [self] statusCode in
            checkStopQueueCode(StopQueueStatusCode(rawValue: statusCode) ?? .UnknownError)
        }
    }
    
    private func checkStopQueueCode(_ stopQueueCode: StopQueueStatusCode) {
        switch stopQueueCode {
        case .Success:
            print("찾기 중단 성공🟢")
        case .MatchStaus:
            print("매칭 상태🟠")
        case .FirebaseTokenError:
            FirebaseTokenManager.shared.getIdToken { [self] _ in
                stopSearch()
            }
            print("Firebase Token Error🔴")
        case .NotSignupUser:
            print("미가입 유저😀")
        case .ServerError:
            print("Server Error🔴")
        case .ClientError:
            print("Client Error🔴")
        default:
            break
        }
    }
    
    func searchSasac() {
        let idToken = UserDefaultsHelper.standard.idToken
        guard let coordinate else { return }
        queueService.searchSesac(idToken: idToken, lat: coordinate.lat, long: coordinate.long) { data, statusCode in
            self.checkSearchCode(SearchQueueStatusCode(rawValue: statusCode) ?? .UnknownError, data: data)
        }
    }
    
    private func checkSearchCode(_ searchQueueCode: SearchQueueStatusCode, data: MatchSesac?) {
        switch searchQueueCode {
        case .Success:
            if let data {
                let newData = filterGender(data)
                searchData = newData
                self.data.onNext([newData.fromQueueDB, newData.fromQueueDBRequested])
            }
            print("검색 성공🟢")
        case .FirebaseTokenError:
            FirebaseTokenManager.shared.getIdToken { [weak self] idToken in
                self?.searchSasac()
            }
            print("Firebase Token Error🔴")
        case .NotSignupUser:
            print("미가입 유저😀")
        case .ServerError:
            print("Server Error🔴")
        case .ClientError:
            print("Client Error🔴")
        default:
            break
        }
    }
    
    private func filterGender(_ data: MatchSesac) -> MatchSesac {
        let gender = Gender(rawValue: UserDefaultsHelper.standard.gender)
        var list: [Sesac] = []
        var requestList: [Sesac] = []
        switch gender {
        case .Man:
            list = data.fromQueueDB.filter{$0.gender == Gender.Man.rawValue}
            requestList = data.fromQueueDBRequested.filter{$0.gender == Gender.Man.rawValue}
        case .Woman:
            list = data.fromQueueDB.filter{$0.gender == Gender.Woman.rawValue}
            requestList = data.fromQueueDBRequested.filter{$0.gender == Gender.Woman.rawValue}
        default:
            return data
        }
        
        let newData = MatchSesac(fromQueueDB: list, fromQueueDBRequested: requestList, fromRecommend: data.fromRecommend)

        return newData
    }
    
    func checkMyStatus() {
        let idToken = UserDefaultsHelper.standard.idToken
        queueService.getMyState(idToken: idToken) { [self] matchStatus, statusCode in
            checkMyQueueStatusCode(MyQueueStatusCode(rawValue: statusCode) ?? .UnknownError, data: matchStatus)
        }
    }
    
    private func checkMyQueueStatusCode(_ myQueueStatusCode: MyQueueStatusCode, data: MatchStatus?) {
        switch myQueueStatusCode {
        case .Success:
            guard let data else { return }
            myStatus.accept(data)
            print("매칭 상태 확인 성공🟢")
        case .NomalMode:
            print("일반 상태🟠")
        case .FirebaseTokenError:
            FirebaseTokenManager.shared.getIdToken { idToken in
                self.checkMyStatus()
            }
            print("Firebase Token Error🔴")
        case .NotSignupUser:
            print("미가입 유저😀")
        case .ServerError:
            print("Server Error🔴")
        case .ClientError:
            print("Client Error🔴")
        default:
            break
        }
    }
}
