//
//  FirebaseTokenManager.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/01.
//

import Foundation

import FirebaseAuth

final class FirebaseTokenManager {
    
    private init() {}
    
    static let shared = FirebaseTokenManager()
    
    func getIdToken(complitionHandler: @escaping (String) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }

        currentUser.getIDTokenForcingRefresh(true) { idToken, error in

            complitionHandler(idToken ?? "")
            UserDefaultsHelper.standard.idToken = idToken ?? ""
            print("ID TOKEN: ", UserDefaultsHelper.standard.idToken)
        }
    }
}
