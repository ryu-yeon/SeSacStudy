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
