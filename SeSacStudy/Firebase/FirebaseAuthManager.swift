//
//  FirebaseAuthManager.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/09.
//

import Foundation

import FirebaseAuth

final class FirebaseAuthManager {
    
    func sendSMS(phoneNumber: String, handler: @escaping (Error?) -> Void) {
        PhoneAuthProvider.provider()
          .verifyPhoneNumber("+82 \(phoneNumber)", uiDelegate: nil) { verificationID, error in
              if error != nil {
                  print(error!.localizedDescription)
                  handler(error)
                return
              }
              Auth.auth().languageCode = "kr"
              UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
              handler(error)
          }
    }
    
    func checkCode(code: String, handler: @escaping (Error?) -> ()) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: code)
        
        Auth.auth().signIn(with: credential) { authResult, error in
            print("SIGNIN")
            print("CREDENTIAL",credential)
            print("AUTHRESULT",authResult)
            handler(error)
        }
    }
}
