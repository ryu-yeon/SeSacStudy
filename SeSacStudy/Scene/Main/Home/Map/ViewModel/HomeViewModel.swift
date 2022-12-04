//
//  HomeViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import Foundation

import RxSwift
import RxRelay

final class HomeViewModel {
    
    init() {
        searchSasac()
    }
    
    var coordinate = PublishSubject<Coordinate>()
    var gender = BehaviorRelay(value: Gender.Nothing)
    var statusData = PublishRelay<MatchStatus?>()
    var sesacData = PublishRelay<MatchSesac>()
    
    let queueService = QueueAPIService()
    let locationHelper = LocationHelper()
    let user = UserDefaultsHelper.standard.loadUser()!
    
    var matchSesac: MatchSesac?
    var runTimeInterval: TimeInterval?
    
    let baseCenter = Coordinate(lat: 37.517819364682694, long: 126.88647317074734)
    
    private let disposeBag = DisposeBag()
    
    func checkMyStatus() {
        let idToken = UserDefaultsHelper.standard.idToken
        queueService.getMyState(idToken: idToken) { (data, statusCode) in
            guard let myQueueStatusCode = MyQueueStatusCode(rawValue: statusCode) else { return }
            self.checkMyQueueStatusCode(myQueueStatusCode, data: data)
        }
    }
    
    private func checkMyQueueStatusCode(_ myQueueStatusCode: MyQueueStatusCode, data: MatchStatus?) {
        switch myQueueStatusCode {
        case .Success:
            guard let data else { return }
            print(data)
            statusData.accept(data)
            print("매칭 상태 확인 성공🟢")
        case .NomalMode:
            statusData.accept(nil)
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
    
    private func searchSasac() {
        let idToken = UserDefaultsHelper.standard.idToken
        coordinate
            .subscribe { [self] coordinate in
                queueService.searchSesac(idToken: idToken, lat: coordinate.lat, long: coordinate.long) { [self] data, statusCode in
                    guard let statusCode = StatusCode(rawValue: statusCode) else { return }
                    checkStatusCode(statusCode, data: data) {
                        self.coordinate.onNext(coordinate)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    func checkStatusCode(_ statusCode: StatusCode, data: MatchSesac?, complitionHandler: @escaping () -> Void) {
        switch statusCode {
        case .Success:
            if let data {
                matchSesac = data
                sesacData.accept(data)
            }
            print("검색 성공🟢")
        case .FirebaseTokenError:
            FirebaseTokenManager.shared.getIdToken { _ in
                complitionHandler()
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
