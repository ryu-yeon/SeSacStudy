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
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("IDTOKEN", UserDefaultsHelper.standard.idToken)
        
        setMap()
        setPlaceButton()
        setGenderButton()
        
        bindMatchStatus()
        bindMatchSesac()
        
        Timer.scheduledTimer(timeInterval: 0.25, target: self, selector: #selector(moveMap), userInfo: nil, repeats: true)
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
        guard let timeInterval = viewModel.runTimeInterval else { return }

        let interval = Date().timeIntervalSinceReferenceDate - timeInterval

        if interval < 0.8 { return }

        searchMap()

        viewModel.runTimeInterval = nil
    }
    
    private func bindMatchStatus() {
        viewModel.statusData
            .asDriver(onErrorJustReturn: nil)
            .drive { [self] value in
                switch value?.matched {
                case 0:
                    mainView.flotingButton.setImage(UIImage(named: "matching"), for: .normal)
                    mainView.flotingButton.rx.tap
                        .take(1)
                        .bind { [self] _ in
                            let nextVC = SearchViewController()
                            nextVC.viewModel.searchData = viewModel.matchSesac
                            nextVC.viewModel.lat = mainView.mapView.centerCoordinate.latitude
                            nextVC.viewModel.long = mainView.mapView.centerCoordinate.longitude
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }
                        .disposed(by: disposeBag)
                case 1:
                    mainView.flotingButton.setImage(UIImage(named: "matched"), for: .normal)
                    mainView.flotingButton.rx.tap
                        .take(1)
                        .bind { [self] _ in
                            let nextVC = ChatViewController()
                            nextVC.viewModel.yourNickname = value?.matchedNick ?? ""
                            nextVC.viewModel.yourID = value?.matchedUid ?? ""
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }
                        .disposed(by: disposeBag)
                default:
                    mainView.flotingButton.setImage(UIImage(named: "default"), for: .normal)
                    mainView.flotingButton.rx.tap
                        .take(1)
                        .bind { [self] _ in
                            let nextVC = SetSearchViewController()
                            nextVC.viewModel.searchData = viewModel.matchSesac
                            nextVC.viewModel.lat = mainView.mapView.centerCoordinate.latitude
                            nextVC.viewModel.long = mainView.mapView.centerCoordinate.longitude
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }
                        .disposed(by: disposeBag)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindMatchSesac() {
        viewModel.sesacData
            .map { $0.fromQueueDB}
            .asDriver(onErrorJustReturn: [])
            .drive { [self] value in
                var list: [Sesac] = []
                switch viewModel.gender.value {
                case .Man:
                    list = value.filter{$0.gender == Gender.Man.rawValue}
                case .Woman:
                    list = value.filter{$0.gender == Gender.Woman.rawValue}
                default:
                    list = value
                }
                list.forEach {
                    print($0.nick)
                    setAnnotitaion(lat: $0.lat, long: $0.long, image: $0.sesac)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func setMap() {
        mainView.mapView.delegate = self
        
        let baseCenter = CLLocationCoordinate2D(latitude: viewModel.baseCenter.lat, longitude: viewModel.baseCenter.long)
        
        viewModel.locationHelper.locationManager.delegate = self
        viewModel.locationHelper.checkUserDeviceLocationServiceAuthorization()
        setRegion(center: baseCenter)
    }
    
    private func searchMap() {
        let coordinate = Coordinate(lat: mainView.mapView.centerCoordinate.latitude, long: mainView.mapView.centerCoordinate.longitude)
        viewModel.coordinate.onNext(coordinate)
    }
    
    private func setGenderButton() {
        mainView.totalButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.gender.accept(.Nothing)
            }
            .disposed(by: disposeBag)
        
        mainView.manButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.gender.accept(.Man)
            }
            .disposed(by: disposeBag)
        
        mainView.womanButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.gender.accept(.Woman)
            }
            .disposed(by: disposeBag)
        
        viewModel.gender
            .asDriver(onErrorJustReturn: .Nothing)
            .drive { [self] gender in
                switch gender {
                case .Nothing:
                    mainView.totalButton.setTitleColor(.white, for: .normal)
                    mainView.totalButton.backgroundColor = .brandGreen
                    mainView.womanButton.setTitleColor(.black, for: .normal)
                    mainView.womanButton.backgroundColor = .white
                    mainView.manButton.setTitleColor(.black, for: .normal)
                    mainView.manButton.backgroundColor = .white
                case .Man:
                    mainView.totalButton.setTitleColor(.black, for: .normal)
                    mainView.totalButton.backgroundColor = .white
                    mainView.womanButton.setTitleColor(.black, for: .normal)
                    mainView.womanButton.backgroundColor = .white
                    mainView.manButton.setTitleColor(.white, for: .normal)
                    mainView.manButton.backgroundColor = .brandGreen
                case .Woman:
                    mainView.totalButton.setTitleColor(.black, for: .normal)
                    mainView.totalButton.backgroundColor = .white
                    mainView.womanButton.setTitleColor(.white, for: .normal)
                    mainView.womanButton.backgroundColor = .brandGreen
                    mainView.manButton.setTitleColor(.black, for: .normal)
                    mainView.manButton.backgroundColor = .white
                }
                searchMap()
            }
            .disposed(by: disposeBag)
    }
    
    private func setPlaceButton() {
        mainView.placeButton.rx.tap
            .withUnretained(self)
            .bind { (vc, _) in
                vc.viewModel.locationHelper.startUpdatingLocation()
                vc.searchMap()
            }
            .disposed(by: disposeBag)
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
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let coordinate = locations.last?.coordinate {
            setRegion(center: coordinate)
        }

        viewModel.locationHelper.stopUpdatingLocation()
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
        viewModel.runTimeInterval = Date().timeIntervalSinceReferenceDate
    }
}
