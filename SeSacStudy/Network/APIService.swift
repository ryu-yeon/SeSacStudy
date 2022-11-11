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
            "FCMtoken": UserDefaults.standard.string(forKey: "FCMToken") ?? "",
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
}
