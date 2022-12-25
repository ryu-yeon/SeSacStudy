//
//  ShopViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import Foundation

import RxSwift
import RxRelay

final class ShopViewModel {
    
    let userService = UserAPIService()
    
    let user = UserDefaultsHelper.standard.loadUser()
    
    let vaild = BehaviorRelay(value: false)
    
    var selectSesac = 0
    var selectBackground = 0
    
    func updateItem() {
        let idToken = UserDefaultsHelper.standard.idToken
        userService.updateItem(idToken: idToken, selectSesac: selectSesac, selectBackground: selectBackground) { [self] statusCode in
            let shopItemStatusCode = ShopItemStatusCode(rawValue: statusCode)
            checkStatusCode(shopItemStatusCode: shopItemStatusCode ?? .UnknownError)
        }
    }
    
    func checkStatusCode(shopItemStatusCode: ShopItemStatusCode) {
        switch shopItemStatusCode {
        case .Success:
            vaild.accept(true)
            print("성공🟢")
        case .NotHaveItem:
            vaild.accept(false)
            print("보유하지 않은 아이템 요청🟡")
        case .FirebaseTokenError:
            FirebaseTokenManager.shared.getIdToken { [self] idToken in
                updateItem()
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
