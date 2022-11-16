//
//  HomeView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import UIKit
import MapKit

import JJFloatingActionButton
import SnapKit

final class HomeView: BaseView {
    
    let mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    let containerView2: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    let buttonView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    let totalButton: UIButton = {
        let view = UIButton()
        view.setTitle("전체", for: .normal)
        view.titleLabel?.font = .title4_R14
        view.backgroundColor = .brandGreen
        return view
    }()
    
    let manButton: UIButton = {
        let view = UIButton()
        view.setTitle("남자", for: .normal)
        view.titleLabel?.font = .title4_R14
        view.setTitleColor(.black, for: .normal)
        view.backgroundColor = .white
        return view
    }()
    
    let womanButton: UIButton = {
        let view = UIButton()
        view.setTitle("여자", for: .normal)
        view.titleLabel?.font = .title4_R14
        view.setTitleColor(.black, for: .normal)
        view.backgroundColor = .white
        return view
    }()
    
    let placeButton: UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "place"), for: .normal)
        view.backgroundColor = .white
        view.tintColor = .black
        view.layer.cornerRadius = 8
        return view
    }()
    
    let floatingButton: JJFloatingActionButton = {
        let view = JJFloatingActionButton()
        view.buttonColor = .black
//        view.buttonImageSize = CGSize(width: 64, height: 64)
        view.itemSizeRatio = CGFloat(1)
        view.addItem(image: UIImage(named: "default")?.withRenderingMode(.alwaysTemplate)) { item in
            // do something
        }
        
        view.addItem(image: UIImage(named: "matching")?.withRenderingMode(.alwaysTemplate)) { item in
            item.buttonColor = .black
        }
        
        view.addItem(image: UIImage(named: "matched")) { item in
            // do something
        }
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
        view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .clear
        
        [totalButton, manButton, womanButton].forEach {
            buttonView.addSubview($0)
        }
        
        containerView.addSubview(buttonView)
        containerView2.addSubview(placeButton)
        
        [mapView, containerView, containerView2, floatingButton].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        mapView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(48)
            make.height.equalTo(144)
        }
        
        buttonView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        totalButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(48)
        }
        
        manButton.snp.makeConstraints { make in
            make.top.equalTo(totalButton.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(48)
        }
        
        womanButton.snp.makeConstraints { make in
            make.top.equalTo(manButton.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(48)
        }
        
        containerView2.snp.makeConstraints { make in
            make.top.equalTo(buttonView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(48)
        }
        
        placeButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(64)
        }
    }
}
