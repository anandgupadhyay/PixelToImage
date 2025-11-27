////
////  AnimatedGradientView.swift
////  PixelToImage
////
////  Created by Anand Upadhyay on 27/11/25.
////
//
//import UIKit
//
//class AnimatedGradientView: UIView {
//
//    private let gradient = CAGradientLayer()
//    private let animation = CABasicAnimation(keyPath: "locations")
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//
//    private func setup() {
//        gradient.colors = [
//            UIColor.systemPink.withAlphaComponent(0.5).cgColor,
//            UIColor.systemPurple.withAlphaComponent(0.4).cgColor,
//            UIColor.systemGreen.withAlphaComponent(0.4).cgColor
//        ]
//
//        gradient.startPoint = CGPoint(x: 0, y: 0.5)
//        gradient.endPoint   = CGPoint(x: 1, y: 0.5)
//        gradient.locations   = [0, 0.5, 1]
//
//        layer.insertSublayer(gradient, at: 0)
//        layer.cornerRadius = 25
//        layer.masksToBounds = true
//        
//        startAnimation()
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        gradient.frame = bounds
//    }
//
//    func startAnimation() {
//        animation.fromValue = [-1, -0.5, 0]
//        animation.toValue   = [1, 1.5, 2]
//        animation.duration  = 3.0
//        animation.repeatCount = .infinity
//        animation.autoreverses = false
//        gradient.add(animation, forKey: "gradientShift")
//    }
//}
//
//struct AnimatedGradientButtonSample: View {
//    var body: some View {
//        AnimatedGradientButtonRepresentable()
//    }
//}
//
//class AnimatedGradientButton: UIButton {
//
//    private let animatedBackground = AnimatedGradientView()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setup()
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setup()
//    }
//
//    private func setup() {
//        clipsToBounds = false
//        setTitle("Press Here", for: .normal)
//        setTitleColor(.systemBlue, for: .normal)
//        titleLabel?.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
//        
//        insertSubview(animatedBackground, at: 0)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        animatedBackground.frame = bounds
//        layer.cornerRadius = bounds.height / 2
//    }
//    
//    var body: some View {
//        HStack{
//            Spacer()
//            AnimatedGradientButtonRepresentable()
//                .frame(width: 220, height: 70)
//            Spacer()
//        }
//    }
//}
//
//
////Using in UIKit
////let btn = AnimatedGradientButton(frame: CGRect(x: 50, y: 200, width: 220, height: 70))
////view.addSubview(btn)
//
////SwiftUI Wrapper
//import SwiftUI
//
//struct AnimatedGradientButtonRepresentable: UIViewRepresentable {
//
//    func makeUIView(context: Context) -> AnimatedGradientButton {
//        return AnimatedGradientButton()
//    }
//
//    func updateUIView(_ uiView: AnimatedGradientButton, context: Context) {}
//}
//
////struct AnimatedGradientButton: View {
////    var body: some View {
////        AnimatedGradientButtonRepresentable()
////            .frame(width: 220, height: 70)
////    }
////}
//
//
