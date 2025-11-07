//
//  SwiftUIExample.swift
//  PixelToImage
//
//  Created by Anand Upadhyay on 06/11/25.
//
import SwiftUI
import UIKit

// Reuse the CircleAnimationContainerView class from previous code here.

struct CircleAnimationView: UIViewRepresentable {
    @Binding var numberOfCircles: Int
    @Binding var circleFillStyles: [CircleAnimationContainerView.CircleFillStyle]
    @Binding var movementSpeed: CGFloat
    @Binding var blurLevel: CGFloat
    
    let containerView = CircleAnimationContainerView()
    
    func makeUIView(context: Context) -> CircleAnimationContainerView {
        containerView.numberOfCircles = numberOfCircles
        containerView.circleFillStyles = circleFillStyles
        containerView.movementSpeed = movementSpeed
        containerView.blurLevel = blurLevel
        containerView.startAnimation()
        return containerView
    }
    
    func updateUIView(_ uiView: CircleAnimationContainerView, context: Context) {
        uiView.numberOfCircles = numberOfCircles
        uiView.circleFillStyles = circleFillStyles
        uiView.movementSpeed = movementSpeed
        uiView.blurLevel = blurLevel
        
        if !uiView.isAnimating {
            uiView.startAnimation()
        }
    }
    
    func stopAnimation() {
        containerView.stopAnimation()
    }
}

struct SwiftUIExample: View {
    @State private var numCircles = 4
    @State private var fillStyles: [CircleAnimationContainerView.CircleFillStyle] = [
        .gradient([.red, .orange]),
        .gradient([.magenta, .cyan, .pink]),
        .gradient([.yellow, .blue, .blue]),
        .gradient([.blue, .purple,.white])
    ]
    @State private var speed: CGFloat = 216
    @State private var blur: CGFloat = 10
    
    var body: some View {
        VStack {
            Text("Bouncing Circles Animation")
                .font(.title)
                .padding()
            
            Rectangle()
                .fill(Color.black.opacity(0.1))
                .frame(width: 400, height: 250)
                .overlay(
                    CircleAnimationView(numberOfCircles: $numCircles,
                                        circleFillStyles: $fillStyles,
                                        movementSpeed: $speed,
                                        blurLevel: $blur)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                )
                .padding()
            
            VStack(spacing: 15) {
                Text("Speed: \(Int(speed)) points/sec")
                Slider(value: $speed, in: 30...300)
                
                Text("Blur Level: \(Int(blur))")
                Slider(value: $blur, in: 0...30)
            }
            .padding()
        }
    }
}

#Preview {
    SwiftUIExample()
}

