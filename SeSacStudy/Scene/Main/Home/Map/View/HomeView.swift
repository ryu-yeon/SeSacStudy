//
//  HomeView.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/11.
//

import UIKit
import MapKit

import SnapKit

final class HomeView: BaseView {
    
    let mapView: MKMapView = {
        let view = MKMapView()
        return view
    }()
    
    let mapMarkerImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "map_marker")
        return view
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowRadius = 8
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
    
    let placeButton: ButtonWithShadow = {
        let view = ButtonWithShadow()
        view.setImage(UIImage(named: "place"), for: .normal)
        view.tintColor = .black
        view.backgroundLayerColor = .white
        view.conerRadius = 8
        return view
    }()
    
    let flotingButton: ButtonWithShadow = {
        let view = ButtonWithShadow()
        view.setImage(UIImage(named: "default"), for: .normal)
        view.tintColor = .black
        view.backgroundLayerColor = .clear
        view.conerRadius = 32
        return view
    }()
    
    let flotingButton2: ButtonWithShadow = {
        let view = ButtonWithShadow()
        view.setImage(UIImage(named: "matching"), for: .normal)
        view.tintColor = .black
        view.backgroundLayerColor = .clear
        view.conerRadius = 32
        view.isHidden = true
        return view
    }()
    
    let flotingButton3: ButtonWithShadow = {
        let view = ButtonWithShadow()
        view.setImage(UIImage(named: "matched"), for: .normal)
        view.tintColor = .black
        view.backgroundLayerColor = .clear
        view.conerRadius = 32
        view.isHidden = true
        return view
    }()
    
    override func configureUI() {
        self.backgroundColor = .clear
        
        [totalButton, manButton, womanButton].forEach {
            buttonView.addSubview($0)
        }
        
        containerView.addSubview(buttonView)
        
        [mapView, mapMarkerImageView, containerView, placeButton, flotingButton, flotingButton2, flotingButton3].forEach {
            self.addSubview($0)
        }
    }
    
    override func setConstraints() {
        
        mapView.snp.makeConstraints { make in
            make.horizontalEdges.verticalEdges.equalToSuperview()
        }
        
        mapMarkerImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
        
        placeButton.snp.makeConstraints { make in
            make.top.equalTo(buttonView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(16)
            make.size.equalTo(48)
        }
        
        flotingButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(16)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(64)
        }
        
        flotingButton2.snp.makeConstraints { make in
            make.bottom.equalTo(flotingButton.snp.top).offset(-4)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(64)
        }
        
        flotingButton3.snp.makeConstraints { make in
            make.bottom.equalTo(flotingButton2.snp.top).offset(-4)
            make.trailing.equalToSuperview().inset(16)
            make.size.equalTo(64)
        }
    }
}
