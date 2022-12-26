//
//  StatusCode.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/04.
//

import Foundation

enum StatusCode: Int {
    case Success = 200
    case FirebaseTokenError = 401
    case NotSignupUser = 406
    case ServerError = 500
    case ClientError = 501
    case UnknownError = -1
}

enum UserStatusCode: Int {
    case Success = 200
    case SignInUser = 201
    case InvaliedNickName = 202
    case FirebaseTokenError = 401
    case NotSignupUser = 406
    case ServerError = 500
    case ClientError = 501
    case UnknownError = -1
}

enum FirebaseAuthStatusCode: Int {
    case Success = 0
    case ManyTry = 17010
    case UnknownError = -1
    case Fail = -2
    
    var message: String {
        switch self {
        case .Success:
            return "전화 번호 인증 시작"
        case .ManyTry:
            return "과도한 인증 시도가 있었습니다. 나중에 다시 시도해 주세요."
        case .UnknownError:
            return "에러가 발생했습니다. 다시 시도해주세요."
        case .Fail:
            return "전화 번호 인증 실패"
        }
    }
}

enum InVaild: String {
    case Phone
    case Nickname
    case Birth
    case Email
    case Gender
    case StudyName
    case StudyCount
    case DuplicatedStudy
    
    var message: String {
        switch self {
        case .Phone:
            return "잘못된 전화번호 형식입니다."
        case .Nickname:
            return "닉네임은 1자 이상 10자 이내로 부탁드려요."
        case .Birth:
            return "새싹스터디는 만 17세 이상만 사용할 수 있습니다."
        case .Email:
            return "이메일 형식이 올바르지 않습니다."
        case .Gender:
            return "성별을 선택해 주세요."
        case .StudyName:
            return "최소 한 자 이상, 최대 8글자까지 작성 가능합니다."
        case .StudyCount:
            return "스터디를 더 이상 추가할 수 없습니다."
        case .DuplicatedStudy:
            return "이미 등록된 스터디입니다."
        }
    }
    
}

enum MyQueueStatusCode: Int {
    case Success = 200
    case NomalMode = 201
    case FirebaseTokenError = 401
    case NotSignupUser = 406
    case ServerError = 500
    case ClientError = 501
    case UnknownError = -1
}

enum SearchQueueStatusCode: Int {
    case Success = 200
    case BlackList = 201
    case PenaltyLv1 = 203
    case PenaltyLv2 = 204
    case PenaltyLv3 = 205
    case FirebaseTokenError = 401
    case NotSignupUser = 406
    case ServerError = 500
    case ClientError = 501
    case UnknownError = -1
    
    var message: String {
        switch self {
        case .BlackList:
            return "신고가 누적되어 이용하실 수 없습니다"
        case .PenaltyLv1:
            return "스터디 취소 패널티로, 1분동안 이용하실 수 없습니다"
        case .PenaltyLv2:
            return "스터디 취소 패널티로, 2분동안 이용하실 수 없습니다"
        case .PenaltyLv3:
            return "스터디 취소 패널티로, 3분동안 이용하실 수 없습니다"
        default:
            return ""
        }
    }
}

enum StopQueueStatusCode: Int {
    case Success = 200
    case MatchStaus = 201
    case FirebaseTokenError = 401
    case NotSignupUser = 406
    case ServerError = 500
    case ClientError = 501
    case UnknownError = -1
}

enum ShopItemStatusCode: Int {
    case Success = 200
    case NotHaveItem = 201
    case FirebaseTokenError = 401
    case NotSignupUser = 406
    case ServerError = 500
    case ClientError = 501
    case UnknownError = -1
    
    var message: String {
        switch self {
        case .Success:
            return "성공적으로 저장되었습니다."
        default:
            return "구매가 필요한 아이템이 있어요."
        }
    }
}
    
enum BuyStatusCode: Int {
    case Success = 200
    case Fail = 201
    case FirebaseTokenError = 401
    case NotSignupUser = 406
    case ServerError = 500
    case ClientError = 501
    case UnknownError = -1
}
    
