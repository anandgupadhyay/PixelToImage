//
//  AGVUIKit.swift
//  PixelToImage
//
//  Created by Anand Upadhyay on 06/11/25.
//

import UIKit

extension UIColor {
    static var pink: UIColor { UIColor(red: 1.0, green: 0.75, blue: 0.8, alpha: 1.0) }
}


//For UI Kit
//class AnimatedGradientView: UIView {
//    private let gradientLayer = CAGradientLayer()
//
//    var colors: [UIColor] = [.purple, .green, .white, .pink] {
//        didSet { gradientLayer.colors = colors.map { $0.cgColor } }
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        gradientLayer.frame = bounds
//    }
//
//    func animate() {
//        let animation = CABasicAnimation(keyPath: "startPoint")
//        animation.fromValue = CGPoint(x: 0, y: 0)
//        animation.toValue = CGPoint(x: 1, y: 1)
//        animation.duration = 3
//        animation.repeatCount = .infinity
//        animation.autoreverses = true
//        gradientLayer.add(animation, forKey: "startPointAnimation")
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//    required init?(coder: NSCoder) { super.init(coder: coder); setup() }
//
//    private func setup() {
//        gradientLayer.colors = colors.map { $0.cgColor }
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
//        layer.insertSublayer(gradientLayer, at: 0)
//        animate()
//        layer.cornerRadius = bounds.height / 2
//        clipsToBounds = true
//    }
//}
