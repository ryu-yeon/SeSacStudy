//
//  HomeViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import UIKit

import CoreLocation
import MapKit

import RxCocoa
import RxSwift

final class HomeViewController: BaseViewController {
    
    private let mainView = HomeView()
    private let viewModel = HomeViewModel()
    private let disposeBag = DisposeBag()
    
    let locationManager = CLLocationManager()
    
    var runTimeInterval: TimeInterval?
    
    var genderButton = -1
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("IDTOKEN", UserDefaultsHelper.standard.idToken)
        
        setMap()
        setPlaceButton()
        setGenderButton()
        
        Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(moveMap), userInfo: nil, repeats: true)

        mainView.mapView.delegate = self
        
        viewModel.statusData
            .bind { value in
                self.setFloatingButton(status: value)
                print(value?.matched ?? "nil")
            }
            .disposed(by: disposeBag)
        
        viewModel.sesacData
            .withUnretained(self)
            .bind { (vc, value) in
                vc.mainView.mapView.removeAnnotations(vc.mainView.mapView.annotations)
                let sesacList = value.fromQueueDB
                var list: [Sesac] = []
                switch self.genderButton {
                case 0:
                    list = sesacList.filter{$0.gender == 0}
                case 1:
                    list = sesacList.filter{$0.gender == 1}
                default:
                    list = sesacList
                }
                list.forEach {
                    print($0.nick)
                    vc.setAnnotitaion(lat: $0.lat, long: $0.long, image: $0.sesac)
                }
                list.removeAll()
            }
            .disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.checkMyStatus()
        searchMap()

        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc func moveMap() {
        guard let timeInterval = runTimeInterval else { return }
        
        let interval = Date().timeIntervalSinceReferenceDate - timeInterval
        
        if interval < 0.8 { return }
        
        searchMap()
        
        runTimeInterval = nil
    }
    
    
    private func setMap() {
        
        let baseCenter = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
        locationManager.delegate = self
        checkUserDeviceLocationServiceAuthorization()
        setRegion(center: baseCenter)
    }
    
    private func searchMap() {
        
        let coordinate = mainView.mapView.centerCoordinate
        viewModel.searchSasac(lat: coordinate.latitude, long: coordinate.longitude)
    }
    
    private func setGenderButton() {
        mainView.totalButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.genderButton = -1
                vc.mainView.totalButton.setTitleColor(.white, for: .normal)
                vc.mainView.totalButton.backgroundColor = .brandGreen
                vc.mainView.womanButton.setTitleColor(.black, for: .normal)
                vc.mainView.womanButton.backgroundColor = .white
                vc.mainView.manButton.setTitleColor(.black, for: .normal)
                vc.mainView.manButton.backgroundColor = .white
                vc.searchMap()
            }
            .disposed(by: disposeBag)
        mainView.womanButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.genderButton = 0
                vc.mainView.totalButton.setTitleColor(.black, for: .normal)
                vc.mainView.totalButton.backgroundColor = .white
                vc.mainView.womanButton.setTitleColor(.white, for: .normal)
                vc.mainView.womanButton.backgroundColor = .brandGreen
                vc.mainView.manButton.setTitleColor(.black, for: .normal)
                vc.mainView.manButton.backgroundColor = .white
                vc.searchMap()
            }
            .disposed(by: disposeBag)
        mainView.manButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.genderButton = 1
                vc.mainView.totalButton.setTitleColor(.black, for: .normal)
                vc.mainView.totalButton.backgroundColor = .white
                vc.mainView.womanButton.setTitleColor(.black, for: .normal)
                vc.mainView.womanButton.backgroundColor = .white
                vc.mainView.manButton.setTitleColor(.white, for: .normal)
                vc.mainView.manButton.backgroundColor = .brandGreen
                vc.searchMap()
            }
            .disposed(by: disposeBag)
    }
    
    private func setPlaceButton() {
        mainView.placeButton.addTarget(self, action: #selector(placeButtonClicked), for: .touchUpInside)
    }
    
    @objc func placeButtonClicked() {
        locationManager.startUpdatingLocation()
        searchMap()
    }
    
    private func setFloatingButton(status: MatchStatus?) {
        
        mainView.flotingButton.addTarget(self, action: #selector(floatingButtonClicked), for: .touchUpInside)
        
        guard let matchStatus = status else {
            mainView.flotingButton.setImage(UIImage(named: "default"), for: .normal)
            return
        }
        
        let buttonImage = matchStatus.matched == 0 ? UIImage(named: "matching") : UIImage(named: "matched")
        
        mainView.flotingButton.setImage(buttonImage, for: .normal)
    }
    
    @objc func floatingButtonClicked() {
        
        guard let matchStatus = viewModel.matchStatus else {
            let nextVC = SetSearchViewController()
            
            nextVC.viewModel.searchData = viewModel.matchSesac
            nextVC.viewModel.lat = mainView.mapView.centerCoordinate.latitude
            nextVC.viewModel.long = mainView.mapView.centerCoordinate.longitude
            self.navigationController?.pushViewController(nextVC, animated: true)
            return
        }
        
        if matchStatus.matched == 0 {
            let nextVC = SearchViewController()
            nextVC.viewModel.searchData = viewModel.matchSesac
            nextVC.viewModel.lat = mainView.mapView.centerCoordinate.latitude
            nextVC.viewModel.long = mainView.mapView.centerCoordinate.longitude
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = ChatViewController()
            nextVC.viewModel.yourNickname = matchStatus.matchedNick ?? ""
            nextVC.viewModel.yourID = matchStatus.matchedUid ?? ""
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

extension HomeViewController {
    
    func setRegion(center: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
        mainView.mapView.setRegion(region, animated: true)
    }
    
    func setAnnotitaion(lat: Double, long: Double, image: Int) {
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let annotation = CustomAnnotation(sesac_image: image, coordinate: coordinate)
        mainView.mapView.addAnnotation(annotation)
    }
    
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        authorizationStatus = locationManager.authorizationStatus
        checkUserCurrentLocationAuthorization(authorizationStatus)
    }
    
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        switch authorizationStatus {
        case .notDetermined:
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        case .restricted, .denied:
            print("설정으로 유도")
            // 아이폰 설정으로 유도
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print("DEFAULT")
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            setRegion(center: coordinate)
        }

        locationManager.stopUpdatingLocation()
    }
}

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        guard let annotation = annotation as? CustomAnnotation else {
            return nil
        }
           
        var annotationView = self.mainView.mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotationView.identifier)
            annotationView?.canShowCallout = false
            annotationView?.contentMode = .scaleAspectFit
            
        } else {
            annotationView?.annotation = annotation
        }
        
        let sesacImage: UIImage!
        let size = CGSize(width: 85, height: 85)
        UIGraphicsBeginImageContext(size)
        
        switch annotation.sesac_image {
        case 0:
            sesacImage = UIImage(named: "sesac_face_1")
        case 1:
            sesacImage = UIImage(named: "sesac_face_2")
        case 2:
            sesacImage = UIImage(named: "sesac_face_3")
        case 3:
            sesacImage = UIImage(named: "sesac_face_4")
        case 4:
            sesacImage = UIImage(named: "sesac_face_5")
        default:
            sesacImage = UIImage(named: "sesac_face_1")
        }
        
        sesacImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        annotationView?.image = resizedImage
        annotationView?.layer.cornerRadius = size.width / 2
        annotationView?.layer.borderWidth = 1
        annotationView?.layer.borderColor = UIColor.gray2.cgColor
        annotationView?.clipsToBounds = true
        
        return annotationView
    }
    
    func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
        runTimeInterval = Date().timeIntervalSinceReferenceDate
    }
}
