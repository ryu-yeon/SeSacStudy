//
//  SearchViewModel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/24.
//

import Foundation

import RxCocoa
import RxSwift

final class SearchViewModel {
    
    let apiService = APIService()
    
    let firebaseAuthManager = FirebaseAuthManager()
    
    var searchData: MatchSesac?
    
    var lat: Double!
    
    var long: Double!
    
}
