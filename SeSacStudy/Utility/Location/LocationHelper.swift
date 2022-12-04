//
//  LocationHelper.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/12/05.
//

import Foundation

import CoreLocation

final class LocationHelper {
    
    let locationManager = CLLocationManager()
    
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
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}
