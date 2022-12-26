//
//  BackgroundItem.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/25.
//

import Foundation

struct BackgroundItem {
    let background: BackgroundImage
    let title: String
    let detail: String
    let price: String
    
    static let list: [BackgroundItem] = [
        BackgroundItem(background: BackgroundImage(rawValue: 0)!, title: "하늘 공원", detail: "새싹들을 많이 마주치는 매력적인 하늘 공원입니다.", price: "0"),
        BackgroundItem(background: BackgroundImage(rawValue: 1)!, title: "씨티 뷰", detail: "창밖으로 보이는 도시 야경이 아름다운 공간입니다.", price: "1,200"),
        BackgroundItem(background: BackgroundImage(rawValue: 2)!, title: "밤의 산책로", detail: "어둡지만 무섭지 않은 조용한 산책로입니다.", price: "1,200"),
        BackgroundItem(background: BackgroundImage(rawValue: 3)!, title: "낮의 산책로", detail: "즐겁고 가볍게 걸을 수 있는 산책로입니다.", price: "1,200"),
        BackgroundItem(background: BackgroundImage(rawValue: 4)!, title: "연극 무대", detail: "연극의 주인공이 되어 연기를 펼칠 수 있는 무대입니다.", price: "2,500"),
        BackgroundItem(background: BackgroundImage(rawValue: 5)!, title: "라틴 거실", detail: "모노톤의 따스한 감성의 거실로 편하게 쉴 수 있는 공간입니다.", price: "2,500"),
        BackgroundItem(background: BackgroundImage(rawValue: 6)!, title: "홈트방", detail: "집에서 운동을 할 수 있도록 기구를 갖춘 방입니다.", price: "2,500"),
        BackgroundItem(background: BackgroundImage(rawValue: 7)!, title: "뮤지션 작업실", detail: "여러가지 음악 작업을 할 수 있는 작업실입니다.", price: "2,500")
    ]
    
    static let productIdentifiers: Set<String> = ["com.memolease.sesac1.background1", "com.memolease.sesac1.background2", "com.memolease.sesac1.background3", "com.memolease.sesac1.background4", "com.memolease.sesac1.background5", "com.memolease.sesac1.background6", "com.memolease.sesac1.background7"]
}

