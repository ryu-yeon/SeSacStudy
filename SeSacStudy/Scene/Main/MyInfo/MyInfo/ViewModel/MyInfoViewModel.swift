//
//  MyInfoViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import Foundation

import RxSwift

struct MyInfoMenu {
    var title: String
    let icon: String
}

final class MyInfoViewModel {
    
    var user = UserDefaultsHelper.standard.loadUser()
    
    var list = PublishSubject<[MyInfoMenu]>()
    
    lazy var menuData = [
        MyInfoMenu(title: user?.nick ?? "", icon: "ellipse"),
        MyInfoMenu(title: "공지사항", icon: "notice"),
        MyInfoMenu(title: "자주 묻는 질문", icon: "faq"),
        MyInfoMenu(title: "1:1 문의", icon: "qna"),
        MyInfoMenu(title: "알림 설정", icon: "setting_alarm"),
        MyInfoMenu(title: "이용약관", icon: "permit")
    ]
    
    func fetch() {
        list.onNext(menuData)
    }
}
