//
//  SesacItem.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/25.
//

import Foundation

struct SesacItem {
    let sesac: SesacImage
    let title: String
    let detail: String
    let price: String
    
    static let list: [SesacItem] = [
        SesacItem(sesac: SesacImage(rawValue: 0)!, title: "기본 새싹", detail: "새싹을 대표하는 기본 식물입니다. 다른 새싹들과 함께 하는 것을 좋아합니다.", price: "0"),
        SesacItem(sesac: SesacImage(rawValue: 1)!, title: "튼튼 새싹", detail: "잎이 하나 더 자라나고 튼튼해진 새나라의 새싹으로 같이 있으면 즐거워집니다.", price: "1,200"),
        SesacItem(sesac: SesacImage(rawValue: 2)!, title: "민트 새싹", detail: "호불호의 대명사! 상쾌한 향이 나서 허브가 대중화된 지역에서 많이 자랍니다.", price: "2,500"),
        SesacItem(sesac: SesacImage(rawValue: 3)!, title: "퍼플 새싹", detail: "새감정을 편안하게 쉬도록 하며 슬프고 우울한 감정을 진정시켜주는 멋진 새싹입니다.", price: "2,500"),
        SesacItem(sesac: SesacImage(rawValue: 4)!, title: "골드 새싹", detail: "화려하고 멋있는 삶을 살며 돈과 인생을 플렉스 하는 자유분방한 새싹입니다.", price: "2,500")
    ]
}

