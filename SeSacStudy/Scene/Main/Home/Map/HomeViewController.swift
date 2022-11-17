//
//  HomeViewController.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/10.
//

import UIKit

import CoreLocation
import MapKit

final class HomeViewController: BaseViewController {
    
    private let mainView = HomeView()
    private let viewModel = HomeViewModel()
    
    let locationManager = CLLocationManager()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setMap()
        setFloatingButton()
        setPlaceButton()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    private func setMap() {
        
        let baseCenter = CLLocationCoordinate2D(latitude: 37.517819364682694, longitude: 126.88647317074734)
        locationManager.delegate = self
        checkUserDeviceLocationServiceAuthorization()
        setRegion(center: baseCenter)
    }
    
    private func setPlaceButton() {
        mainView.placeButton.addTarget(self, action: #selector(placeButtonClicked), for: .touchUpInside)
    }
    
    @objc func placeButtonClicked() {
        locationManager.startUpdatingLocation()
    }
    
    private func setFloatingButton() {
        
        mainView.flotingButton.addTarget(self, action: #selector(floatingButtonClicked), for: .touchUpInside)
        
        guard let matchStatus = viewModel.matchStatus else {
            mainView.flotingButton.setImage(UIImage(named: "default"), for: .normal)
            return
        }
        
        let buttonImage = matchStatus.matched == 0 ? UIImage(named: "matching") : UIImage(named: "matched")
        
        mainView.flotingButton.setImage(buttonImage, for: .normal)
    }
    
    @objc func floatingButtonClicked() {
        
        guard let matchStatus = viewModel.matchStatus else {
            let nextVC = SetSearchViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
            return
        }
        
        if matchStatus.matched == 0 {
            let nextVC = SearchViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = ChatViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}

extension HomeViewController {
    
    func setRegion(center: CLLocationCoordinate2D) {
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 700, longitudinalMeters: 700)
        mainView.mapView.setRegion(region, animated: true)
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
