# **새싹 스터디 - Service Levle Project**

<img src="">

<br> 

## **개발기간**
### 2022.11.07 ~


<br>

---
## **🛠️ Framwork & Tech Stack**
- ### MVC, MVVM
- ### UIKit
- ### SnapKit
    - CodeBase UI, AutoLayout 구성
- ### Alamofire
    - 네트워크 통신에서 Alamofire를 이용
    - Codable 데이터 모델 사용
- ### SocketIO
    - 채팅 소켓통신
- ### Realm
    -  채팅 기록 DB 구성
- ### RxSwift, RxCocoa
    - 비동기, 반응형 프로그래밍 구성
- ### RxKeyboard
    - 키보드 동작시 UI 수정
- ### Firebase Auth
    - 전화번호 로그인 & 회원가입
- ### FCM, Push Notification
    - 유저 채팅, 이벤트 푸시메세지 알림
- ### MapKit
    - Apple 지도 표시, Custom Annotion
- ### CoreLocation
    - 현재 위치정보
- ### Toast
    - 간단한 팝업 메시지 UI 구성
- ### MultiSlider
- ### In-App Purchase


<br>

---
## **🔴 Trouble Shooting**

### 1. PageControl 클릭시 CollectionView가 스크롤 ❌
- ```scrollRectToVisible```로 해결
```swift
mainView.pageControl.addTarget(self, action: #selector(pageChanged), for: .valueChanged) 
    
@objc func pageChanged() {
  let index = IndexPath(item: mainView.pageControl.currentPage, section: 0)
  let rect = mainView.collectionView.layoutAttributesForItem(at: index)?.frame
  mainView.collectionView.scrollRectToVisible(rect!, animated: true)
}
```

### 2. 서버에서 데이터를 ```nil```로 가져옴
- 서버에서 ```Codable``` 구조체로 가져올때 변수명 불일치 (오타 수정으로 해결)
- 열거형 ```CodingKeys```로 해결가능

### 3. 네트워크 통신에서 배열을 보내는 경우
- ```encoder```의 ```.noBrackets```를 이용하여 파라미터의 ```[]```를 제거하여 해결
```swift
    func searchStudy(idToken: String, lat: Double, long: Double, studyList: [String], complitionHandler: @escaping (Int) -> Void) {
        let url = EndPoint.baseURL + "/v1/queue"
        let headers: HTTPHeaders = [
            "accept" : "application/json",
            "idtoken": idToken
        ]
        
        let parameters: [String: Any] = [
            "long": long,
            "lat": lat,
            "studylist": studyList
        ]
        
        let encoder = URLEncoding(arrayEncoding: .noBrackets)

        AF.request(url, method: .post, parameters: parameters, encoding: encoder, headers: headers).responseString { response in
            
            let statusCode = response.response?.statusCode ?? 0

            complitionHandler(statusCode)
        }
    }
```

<br>

---

## **✍🏻 Learnd**

- ### RxSwift와 MVVM
    - MVVM의 ViewModel을 사용하면서 View에서는 그리는 일만 하고 RxSwift를 이용하여 ViewModel에서 데이터를 처리하는 일만 하는 분리 작업을 통해 효율적인 아키텍쳐를 사용해 볼 수 있었다.
- ### Compositional Layout
    - 하나의 ColletionView에서 다양한 형태를 만들 수 있는 방법중 하나인 Compostional Layout에 대해 알게 되었다.
- ### DiffableDataSource
    - ```snapshot```을 이용하여 CollectionView의 데이터 갱신시 애니매이션 효과를 자연스럽게 줄 수 있게 되었다.
- ### 채팅
    - SocketIO를 이용하여 소켓통신을 하여 채팅 데이터를 받아 NotificationCenter를 통해 데이터를 처리하고 보여주는 방법에 대해 알게 되었다.
- ### Firebase Token
    - 토큰 기반 인증에 대해 알게 되었고 적절한 갱신 시점 처리를 하는데 도움이 되었다.

