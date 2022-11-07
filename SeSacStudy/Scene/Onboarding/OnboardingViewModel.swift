//
//  OnboardingViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/08.
//

import Foundation

import RxCocoa
import RxSwift

final class OnboardingViewModel {
    
    let list = PublishSubject<[OnboardingData]>()
    
    var index: Int?
    
    let data: [OnboardingData] = [
        OnboardingData(text: "위치 기반으로 빠르게\n주위 친구를 확인", image: "onboarding_img1"),
        OnboardingData(text: "스터디를 원하는 친구를\n찾을 수 있어요", image: "onboarding_img2"),
        OnboardingData(text: "SeSAC Study", image: "onboarding_img3")
    ]
    
    func fetch() {
        list.onNext(data)
    }
}
