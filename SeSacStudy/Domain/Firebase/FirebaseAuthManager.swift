//
//  FirebaseAuthManager.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/09.
//

import Foundation

import FirebaseAuth

final class FirebaseAuthManager {
    
    func sendSMS(phoneNumber: String, handler: @escaping (Error?, Int) -> Void) {
        PhoneAuthProvider.provider()
          .verifyPhoneNumber("+82 \(phoneNumber)", uiDelegate: nil) { verificationID, error in
              if let error = error as NSError? {
                  let errCode = AuthErrorCode(_nsError: error)
                  print(error.localizedDescription)
                  handler(error, errCode.errorCode)
                return
              }
              Auth.auth().languageCode = "kr"
              UserDefaultsHelper.standard.authVerificationID = verificationID ?? ""
              handler(error, 0)
          }
    }
    
    func checkCode(code: String, handler: @escaping (Error?) -> ()) {
        let verificationID = UserDefaultsHelper.standard.authVerificationID
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
            UserDefaultsHelper.standard.idToken = idToken ?? ""
            print("ID TOKEN: ", UserDefaultsHelper.standard.idToken)
        }
    }
}
