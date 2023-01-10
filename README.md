# **새싹 스터디 - Service Level Project**

<img src="https://velog.velcdn.com/images/rytak108/post/eb187bf5-8ddc-446e-887c-1f9071ba1a54/image.png">

## **📲 앱 소개**
### 사용자가 지도를 통해 주제에 따라 검색, 매칭, 채팅으로 스터디원을 찾는데 도움을 주는 앱
- 로그인 & 회원가입
- 스터디원 검색, 매칭, 채팅
- 내 정보 확인, 수정, 회원탈퇴
- 프로필 아이콘, 배경화면 인앱결제

## **🗓️ 개발기간**
### 2022.11.07 ~ 22.12.26 (7주)

## **🛠️ Framwork & Tech Stack**
- ### ```MVC```, ```MVVM```
- ### ```UIKit```, ```MapKit```, ```CoreLocation```, ```Push Notification```, ```StoreKit```
- ### ```SnapKit```, ```Alamofire```, ```SocketIO```, ```Realm```, ```RxSwift```, ```RxCocoa```, ```RxKeyboard```, ```Firebase Auth```, ```Firebase Cloud Messaging```, ```Toast```, ```MultiSlider```, ```Tabman```, ```Pageboy```

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

### 2. 전화번호 인증코드 60초 시간 제한
- ```RxSwift```를 이용하여 ```interval``` 60초동안 1초마다 ```Observalbe```을 생성하여 해결
```swift

    class viewModel {
        var timer: Disposable?
    }

    private func setTimer() {
        let startTime = Date()
        
        viewModel.timer?.dispose()
        viewModel.timer = Observable<Int>.interval(
            .seconds(1),
            scheduler: MainScheduler.instance)
        .take(60)
        .withUnretained(self)
        .subscribe(onNext: { (vc, value) in
            let elapseSeconds = Date().timeIntervalSince(startTime)
            vc.mainView.timerLabel.text = "\(60 - Int(elapseSeconds))"
        }, onCompleted: {
            self.viewModel.vaild.accept(false)
            self.viewModel.timer?.dispose()
        })
    }
```


### 3. 서버에서 데이터를 ```nil```로 가져옴
- 서버에서 ```Codable``` 구조체로 가져올때 변수명 불일치 (오타 수정으로 해결)
- 열거형 ```CodingKeys```로 해결가능

### 4. 네트워크 통신에서 배열을 보내는 경우
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

### 5. UserDefaults에 구조체 형태로 값 저장 & 불러오기
- ```PropertyListEncoder```를 이용해 ```encode```를 하여 값 저장
- ```PropertyListDecoder```를 이용해 ```decode```를 하여 값 불러오기

```swift
    func saveUser(user: User?) {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(user), forKey: Key.user.rawValue)
    }
    
    func loadUser() -> User? {
        guard let savedData = UserDefaults.standard.value(forKey: Key.user.rawValue) as? Data, let user = try? PropertyListDecoder().decode(User.self, from: savedData) else { return nil}
        return user
    }
```

---
## **🤔 회고**
- 프로젝트 초반에 화면을 그릴때 디자인에 맞추어 절대적 값으로 ```AutoLayout```을 정하고 ```View```들을 구성했는데, 이 방식으로 화면을 그릴때 디바이스 해상도에 따라 짤리는 컨텐츠가 발생하는 화면이 있었다.(ex, 인증, 회원가입 부분) 화면을 구성할때 ```AutoLayout```을 맞출때 비율로 할것인지 값으로 할것인지에 대해 어떤 방식이 그 화면에 맞는 방법인지에 대해 다시 한번 생각해보게 되었다.

- 몇몇 화면의 ```ColletionView```를 ```CompostionalLayout```을 활용하여 구성해봤는데 사용할수록 ```FlowLayout```과 달리 여러가지 형태의 Layout을 구성할수있는 점에 대해 놀라웠다. 화면의 형태 구성에서 어떤한 Layout이 더 좋은 방법일까에 대해 생각해보게되었다.

- 네트워크를 통신하는 함수에서 요청하거나 응답할때 ```header```, ```url```, ```method``` 등의 중복되는 부분의 구조체를 활용하여 더 깔끔하게 처리했으면 어떨까라는 생각이 들었고 리펙토링하게 된다면 ```Moya```라는 네트워킹 라이브러리를 사용해 보고싶다는 생각이 들었다.

- 네트워크 통신에서 ```StatusCode```를 받아 올때 처리하는 부분을 ```Switch```를 이용하여 통신 성공, 실패시 로직 처리를 달리 했는데 중복되는 코드가 있는 부분이 있을때가 있는데 이 부분에 있어 고민해보고 다음 리팩토링에서 개선하고싶다.

- ```MVVM```의 ```ViewModel```을 사용하면서 ```View```에서는 그리는 일만 하고 ```RxSwift```를 이용하여 ```ViewModel```에서 데이터를 처리하는 일만 하는 분리 작업을 통해 효율적인 아키텍쳐를 사용해 볼 수 있었다. 하지만 데이터의 흐름을 파악하기에 약간 아쉽다는 생각이 들었다. input, output으로 ```MVVM```의 패턴을 직관적으로 나타낼수있는것을 보고 리팩토링때 개선해야겠다는 생각을 하게되었다.

