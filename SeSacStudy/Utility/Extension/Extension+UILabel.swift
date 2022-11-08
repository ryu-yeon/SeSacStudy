//
//  Extension+UILabel.swift
//  SeSacStudy
//
//  Created by 유연탁 on 2022/11/08.
//

import UIKit

extension UILabel {
    
    func setLineHeight(lineHeight: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
        paragraphStyle.lineHeightMultiple = lineHeight
        paragraphStyle.alignment = self.textAlignment
        
        let attrString = NSMutableAttributedString()
        if (self.attributedText != nil) {
            attrString.append( self.attributedText!)
        } else {
            attrString.append( NSMutableAttributedString(string: self.text ?? ""))
            attrString.addAttribute(NSAttributedString.Key.font, value: self.font ?? .systemFont(ofSize: 18), range: NSMakeRange(0, attrString.length))
        }
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
    
    func setRangeTextColor(text: String, length: Int, color: UIColor) {
        let attributedString = NSMutableAttributedString(string: text)
        let attrbutes: [NSAttributedString.Key: Any] = [.foregroundColor: color]
        attributedString.addAttributes(attrbutes, range: NSRange(location: 0, length: length))
        self.attributedText = attributedString
    }
}
