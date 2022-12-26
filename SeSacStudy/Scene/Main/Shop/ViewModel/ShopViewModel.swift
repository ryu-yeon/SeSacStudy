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
    
    let user = BehaviorRelay(value: UserDefaultsHelper.standard.loadUser())
    
    let vaild = BehaviorRelay(value: false)
    
    lazy var selectSesac = user.value?.sesac
    lazy var selectBackground = user.value?.background
    
    func updateItem() {
        guard let selectSesac else { return }
        guard let selectBackground else { return }
        print(selectSesac, selectBackground)
        let idToken = UserDefaultsHelper.standard.idToken
        userService.updateItem(idToken: idToken, selectSesac: selectSesac, selectBackground: selectBackground) { [self] statusCode in
            let shopItemStatusCode = ShopItemStatusCode(rawValue: statusCode)
            checkShopStatusCode(shopItemStatusCode ?? .UnknownError)
        }
    }
    
    private func checkShopStatusCode(_ shopItemStatusCode: ShopItemStatusCode) {
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
    
    func buyItem(receipt: String, product: String) {
        let idToken = UserDefaultsHelper.standard.idToken
        userService.buyItem(idToken: idToken, receipt: receipt, product: product) { [self] statusCode in
            checkBuyStatusCode(BuyStatusCode(rawValue: statusCode) ?? .UnknownError, receipt: receipt, product: product)
        }
    }
    
    private func checkBuyStatusCode(_ userStatusCode: BuyStatusCode, receipt: String, product: String) {
        switch userStatusCode {
        case .Success:
            updateProfile()
            print("로그인 성공🟢")
        case .FirebaseTokenError:
            FirebaseTokenManager.shared.getIdToken { idToken in
                self.buyItem(receipt: receipt, product: product)
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
    
    func updateProfile() {
        let idToken = UserDefaultsHelper.standard.idToken
        userService.updateItemInfo(idToken: idToken) { [weak self] user, statusCode in
            self?.checkUserStatusCode(UserStatusCode(rawValue: statusCode) ?? .UnknownError, user: user)
        }
    }
    
    private func checkUserStatusCode(_ userStatusCode: UserStatusCode, user: User?) {
        switch userStatusCode {
        case .Success:
            self.user.accept(user)
            UserDefaultsHelper.standard.saveUser(user: user)
            print("로그인 성공🟢")
        case .FirebaseTokenError:
            FirebaseTokenManager.shared.getIdToken { idToken in
                self.updateProfile()
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
