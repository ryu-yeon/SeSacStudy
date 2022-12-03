//
//  ChatAPIService.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/01.
//

import Foundation

import Alamofire

final class ChatAPIService {
    
    func sendChat(idToken: String, to: String, chat: String, complitionHandler: @escaping (Chat?, Int) -> Void) {
        let url = EndPoint.baseURL + "/v1/chat/" + to
        let headers: HTTPHeaders = [
            "accept" : "application/json",
            "idtoken": idToken
        ]
        
        let parameters: [String: String] = ["chat": chat]
        
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseDecodable(of: Chat.self) { response in
            
            let statusCode = response.response?.statusCode ?? 0
            
            switch response.result {
                
            case .success(let data):
                complitionHandler(data, statusCode)
            case .failure(_):
                complitionHandler(nil, statusCode)
            }
        }
    }
    
    func loadChatList(idToken: String, from: String, lastchatDate: String, complitionHandler: @escaping (ChatList?, Int) -> Void) {
        let url = EndPoint.baseURL + "/v1/chat/" + from + "?lastchatDate=" + lastchatDate
        let headers: HTTPHeaders = [
            "accept" : "application/json",
            "idtoken": idToken
        ]
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: ChatList.self) { response in
            
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
