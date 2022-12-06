//
//  SesacImage.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/07.
//

import Foundation

enum SesacImage: Int {
    case sesac_face_1 = 0
    case sesac_face_2
    case sesac_face_3
    case sesac_face_4
    case sesac_face_5
    
    var image: String {
        switch self {
        case .sesac_face_1:
            return "sesac_face_1"
        case .sesac_face_2:
            return "sesac_face_2"
        case .sesac_face_3:
            return "sesac_face_3"
        case .sesac_face_4:
            return "sesac_face_4"
        case .sesac_face_5:
            return "sesac_face_5"
        }
    }
}
