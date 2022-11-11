//
//  FirebaseAuthManager.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/09.
//

import Foundation

import FirebaseAuth

enum FBAError: Int {
    case manyTry = 17010
}

enum FBAMessage: String {
    case start = "전화 번호 인증 시작"
    case manyTry = "과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요."
    case error = "에러가 발생했습니다. 다시 시도해주세요"
    case invaild = "잘못된 전화번호 형식입니다."
    case fail = "전화 번호 인증 실패"
}

final class FirebaseAuthManager {
    
    func sendSMS(phoneNumber: String, handler: @escaping (Error?, Int?) -> Void) {
        PhoneAuthProvider.provider()
          .verifyPhoneNumber("+82 \(phoneNumber)", uiDelegate: nil) { verificationID, error in
              if let error = error as NSError? {
                  let errCode = AuthErrorCode(_nsError: error)
                  print(error.localizedDescription)
                  handler(error, errCode.errorCode)
                return
              }
              Auth.auth().languageCode = "kr"
              UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
              handler(error, 0)
          }
    }
    
    func checkCode(code: String, handler: @escaping (Error?) -> ()) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            print("SIGNIN")
            handler(error)
        }
    }
    
    func getIdToken(complitionHandler: @escaping (String?) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            complitionHandler(nil)
            return
        }
        currentUser.getIDTokenForcingRefresh(true) { idToken, error in
            if error != nil {
                print("ID TOKEN ERROR")
                complitionHandler(nil)
            return
          }
            complitionHandler(idToken)
            UserDefaults.standard.set(idToken, forKey: "token")
            print("ID TOKEN: ", UserDefaults.standard.string(forKey: "token")!)
        }
    }
}
