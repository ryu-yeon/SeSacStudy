//
//  ButtonWithShadow.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/17.
//

import UIKit

final class ButtonWithShadow: UIButton {

    private var shadowLayer: CALayer?
    private var backgroundLayer: CALayer?
    
    var backgroundLayerColor: UIColor?
    var conerRadius: CGFloat?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setConfiguration()

    }

    public override func draw(_ rect: CGRect) {
        configureLayers(rect)
    }

    private func setConfiguration() {
        if #available(iOS 15.0, *) {
            configuration = UIButton.Configuration.plain()
        } else {
            adjustsImageWhenHighlighted = false
        }
    }

    private func configureLayers(_ rect: CGRect) {
       if shadowLayer == nil {
           let shadowLayer = CALayer()
           shadowLayer.masksToBounds = false
           shadowLayer.shadowColor = UIColor.black.cgColor
           shadowLayer.shadowOffset = CGSize(width: 0, height: 0)
           shadowLayer.shadowOpacity = 0.3
           shadowLayer.shadowRadius = self.conerRadius ?? 0
           shadowLayer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: rect.height/2).cgPath
           layer.insertSublayer(shadowLayer, at: 0)
           self.shadowLayer = shadowLayer
       }

        if backgroundLayer == nil {
            let backgroundLayer = CALayer()
            backgroundLayer.masksToBounds = true
            backgroundLayer.frame = rect
            backgroundLayer.cornerRadius = self.conerRadius ?? 0
            backgroundLayer.backgroundColor = self.backgroundLayerColor?.cgColor
            layer.insertSublayer(backgroundLayer, at: 1)
            self.backgroundLayer = backgroundLayer
        }
   }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
