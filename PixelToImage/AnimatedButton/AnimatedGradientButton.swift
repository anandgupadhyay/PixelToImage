//
//  AnimatedGradientButton.swift
//  PixelToImage
//
//  Created by Anand Upadhyay on 08/11/25.
//

import SwiftUI

struct AnimatedGradientButtonSample: View {
    var body: some View {
        AnimatedGradientButton()
    }
}

struct AnimatedGradientButton: View {
    @State private var animate = false
    
    // Customize these colors for your pastel effect
    let gradientColors: [Color] = [
        Color(red: 1.0, green: 0.8, blue: 0.9), // pink
        Color(red: 0.7, green: 0.8, blue: 1.0), // blue
        Color(red: 0.8, green: 1.0, blue: 0.8), // green
        Color(red: 1.0, green: 1.0, blue: 0.8)  // yellow
    ]
    
    var body: some View {
        ZStack {
            // Animated angular gradient behind the button label
            AngularGradient(
                gradient: Gradient(colors: gradientColors),
                center: .center,
                angle: .degrees(animate ? 360 : 0)
            )
            .animation(
                .linear(duration: 4).repeatForever(autoreverses: false),
                value: animate
            )
            .mask(
                RoundedRectangle(cornerRadius: 35)
                    .frame(width: 320, height: 104)
            )
            .blur(radius: 8)
            .opacity(0.85)

            // Button label
            Text("Press Here")
                .font(.system(size: 40, weight: .medium))
                .foregroundColor(.blue)
                .frame(width: 320, height: 104)
                .background(
                    // Soft white background for the button
                    RoundedRectangle(cornerRadius: 35)
                        .fill(Color.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.10), radius: 14, x: 1, y: 5)
                )
                .overlay(
                    // Optional white shine overlay for extra depth
                    RoundedRectangle(cornerRadius: 35)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
        }
        .onAppear {
            animate = true
        }
    }
}


