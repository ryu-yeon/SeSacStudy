//
//  APIService.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import Foundation

import Alamofire

final class APIService {
    
    func login(idToken: String, complitionHandler: @escaping (User?, Int) -> Void) {
        let url = EndPoint.baseURL + "/v1/user"
        let headers: HTTPHeaders = [
            "accept" : "application/json",
            "idtoken": idToken
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: User.self) { response in
            
            let statusCode = response.response?.statusCode ?? 0
            print("STATUS CODE", statusCode)
            
            switch response.result {
                
            case .success(let data):
                complitionHandler(data, statusCode)
            case .failure(_):
                complitionHandler(nil, statusCode)
            }
        }
    }
    
    func signup(idToken: String, profile: Profile, complitionHandler: @escaping (Int) -> Void) {
        let url = EndPoint.baseURL + "/v1/user"
        let parameters: [String: Any] = [
            "phoneNumber": profile.phoneNumber,
            "FCMtoken": UserDefaultsHelper.standard.fcmToken,
            "nick": profile.nickname,
            "birth": profile.birth,
            "email": profile.email,
            "gender": profile.gender
        ]
        let headers: HTTPHeaders = [
            "accept" : "application/json",
            "idtoken": idToken,
            "Content-Type": "application/x-www-form-urlencoded"
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseString { response in
            
            let statusCode = response.response?.statusCode
                
            complitionHandler(statusCode ?? 0)
        }
    }
    
    func updateMyPage(user: User, idToken: String, complitionHandler: @escaping (Int) -> Void) {
        let url = EndPoint.baseURL + "/v1/user/mypage"
        let parameters: [String: Any] = [
            "searchable": user.searchable,
            "ageMin": user.ageMin,
            "ageMax": user.ageMax,
            "gender": user.gender,
            "study": user.study
        ]
        let headers: HTTPHeaders = [
            "idtoken": idToken
        ]
        
        AF.request(url, method: .put, parameters: parameters, headers: headers).responseString { response in
            
            let statusCode = response.response?.statusCode
                
            complitionHandler(statusCode ?? 0)
        }
    }
    
    func withDraw(idToken: String, complitionHandler: @escaping (Int) -> Void) {
        let url = EndPoint.baseURL + "/v1/user/withdraw"
        let headers: HTTPHeaders = [
            "idtoken": idToken
        ]
        
        AF.request(url, method: .post, headers: headers).responseString { response in
            
            let statusCode = response.response?.statusCode
                
            complitionHandler(statusCode ?? 0)
        }
    }
    
    func getMyState(idToken: String, complitionHandler: @escaping (MatchStatus?, Int) -> Void) {
        let url = EndPoint.baseURL + "/v1/queue/myQueueState"
        let headers: HTTPHeaders = [
            "idtoken": idToken
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: MatchStatus.self) { response in
            
            let statusCode = response.response?.statusCode ?? 0
            
            switch response.result {
                
            case .success(let data):
                complitionHandler(data, statusCode)
            case .failure(_):
                complitionHandler(nil, statusCode)
            }
        }
    }
    
    func searchSesac(idToken: String, coordinate: Coordinate, complitionHandler: @escaping (MatchSesac?, Int) -> Void) {
        let url = EndPoint.baseURL + "/v1/queue/search"
        let headers: HTTPHeaders = [
            "idtoken": idToken
        ]
        
        let parameters: [String: Double] = [
            "lat": coordinate.lat,
            "long": coordinate.long
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseDecodable(of: MatchSesac.self) { response in
            
            let statusCode = response.response?.statusCode ?? 0
            
            switch response.result {
                
            case .success(let data):
                complitionHandler(data, statusCode)
            case .failure(_):
                complitionHandler(nil, statusCode)
            }
        }
    }
}
