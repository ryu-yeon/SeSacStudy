//
//  UserDefaultsHelper.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/16.
//

import Foundation

enum Key: String {
    case idToken, start, fcmToken, user, authVerificationID
}

final class UserDefaultsHelper {
    
    private init()  { }
    
    static let standard = UserDefaultsHelper()
    
    let userDefault = UserDefaults.standard
    
    var start: Bool {
        get {
            return userDefault.bool(forKey: Key.start.rawValue)
        }
        set {
            userDefault.set(newValue, forKey: Key.start.rawValue)
        }
    }
    
    var authVerificationID: String {
        get {
            return userDefault.string(forKey: Key.authVerificationID.rawValue) ?? ""
        }
        set {
            userDefault.set(newValue, forKey: Key.authVerificationID.rawValue)
        }
    }
    
    var idToken: String {
        get {
            return userDefault.string(forKey: Key.idToken.rawValue) ?? ""
        }
        set {
            userDefault.set(newValue, forKey: Key.idToken.rawValue)
        }
    }
    
    var fcmToken: String {
        get {
            return userDefault.string(forKey: Key.fcmToken.rawValue) ?? ""
        }
        set {
            userDefault.set(newValue, forKey: Key.fcmToken.rawValue)
        }
    }
    
    func saveUser(user: User?) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(user), forKey: Key.user.rawValue)
    }
    
    func loadUser() -> User? {
        guard let savedData = UserDefaults.standard.value(forKey: Key.user.rawValue) as? Data, let user = try? PropertyListDecoder().decode(User.self, from: savedData) else { return nil}
        return user
    }
}