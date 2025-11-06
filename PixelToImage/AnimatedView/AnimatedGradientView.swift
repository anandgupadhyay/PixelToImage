//
//  AnimatedGradientView.swift
//  PixelToImage
//
//  Created by Anand Upadhyay on 06/11/25.
//

import SwiftUI

struct AnimatedGradientView<Content: View>: View {
    let colors: [Color]
    let content: Content
    @State private var animate = false

    init(colors: [Color], @ViewBuilder content: () -> Content) {
        self.colors = colors
        self.content = content()
    }

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: colors),
                           startPoint: animate ? .topLeading : .bottomTrailing,
                           endPoint: animate ? .bottomTrailing : .topLeading)
                .animation(Animation.linear(duration: 3).repeatForever(autoreverses: true), value: animate)
                .onAppear { animate = true }
            content
        }
        .clipShape(Capsule())
    }
}

// Usage Example:
struct DemoButton: View {
    var body: some View {
        AnimatedGradientView(colors: [.purple, .white, .green, .pink]) {
            Text("Press Here")
                .font(.title)
                .foregroundColor(.blue)
                .padding(.horizontal, 40)
                .padding(.vertical, 20)
        }
        .frame(height: 60)
        .shadow(radius: 10)
        .padding()
    }
}

#Preview {
    DemoButton()
}

