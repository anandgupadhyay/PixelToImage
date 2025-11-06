//
//  PixelToImageView.swift
//  PixelToImage
//
//  Created by Anand Upadhyay on 27/10/25.
//

import SwiftUI
import CoreGraphics

import SwiftUI
import CoreGraphics

#if os(macOS)
import AppKit
typealias PlatformImage = NSImage
#else
import UIKit
typealias PlatformImage = UIImage
#endif

extension PlatformImage {
    var cgImageSafe: CGImage? {
        #if os(macOS)
        var rect = CGRect(origin: .zero, size: size)
        return cgImage(forProposedRect: &rect, context: nil, hints: nil)
        #else
        return cgImage
        #endif
    }
}

struct PixelToImageView: View {
    let imageName: String
    @State private var dots: [Dot] = []
    @State private var selectedColor: Color = .orange
    @State private var speed: Double = 0.8
    @State private var scattered = false
    @State private var loadedCGImage: CGImage? = nil
    
    struct Dot: Identifiable {
        let id = UUID()
        var position: CGPoint
        var target: CGPoint
        var opacity: CGFloat
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Canvas { context, size in
                for dot in dots {
                    let path = Path(ellipseIn: CGRect(x: dot.position.x, y: dot.position.y, width: 2.5, height: 2.5))
                    context.fill(path, with: .color(selectedColor.opacity(dot.opacity)))
                }
            }
            .frame(width: 320, height: 400)
            .background(Color.black)
            .cornerRadius(16)
            .shadow(radius: 10)
            .onAppear {
                if loadedCGImage == nil { loadedCGImage = loadCGImageFromAssets(name: imageName) }
                if let cgImg = loadedCGImage { createDots(from: cgImg, width: 320, height: 400) }
            }
            .onTapGesture {
                scattered.toggle()
                withAnimation(.linear(duration: speed)) {
                    updateDots()
                }
            }
            HStack {
                Text("Color:")
                ColorPicker("", selection: $selectedColor)
                    .labelsHidden()
            }
            .padding(.horizontal)
            HStack {
                Text("Speed")
                Slider(value: $speed, in: 0.15...2)
                Text(String(format: "%.2fs", speed))
            }
            .padding(.horizontal)
        }
        .padding()
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    // Use PlatformImage for assets
    private func loadCGImageFromAssets(name: String) -> CGImage? {
        #if os(macOS)
        guard let nsImg = NSImage(named: name) else { return nil }
        return nsImg.cgImageSafe
        #else
        guard let uiImg = UIImage(named: name) else { return nil }
        return uiImg.cgImageSafe
        #endif
    }
    
    private func createDots(from cgImage: CGImage, width: CGFloat, height: CGFloat) {
        var newDots: [Dot] = []
        let scaleX = width / CGFloat(cgImage.width)
        let scaleY = height / CGFloat(cgImage.height)
        guard
            let data = cgImage.dataProvider?.data,
            let ptr = CFDataGetBytePtr(data)
        else {
            dots = []
            return
        }
        for x in stride(from: 0, to: cgImage.width, by: 6) {
            for y in stride(from: 0, to: cgImage.height, by: 6) {
                let offset = ((cgImage.width * y) + x) * 4
                let r = ptr[offset]
                let g = ptr[offset + 1]
                let b = ptr[offset + 2]
                let a = ptr[offset + 3]
                let brightness = (Float(r) + Float(g) + Float(b)) / (3 * 255)
                if a > 128 && brightness > 0.25 {
                    let pos = CGPoint(x: CGFloat(x) * scaleX, y: CGFloat(y) * scaleY)
                    newDots.append(Dot(position: pos, target: pos, opacity: CGFloat(brightness)))
                }
            }
        }
        dots = newDots
    }
    
    private func updateDots() {
        for idx in dots.indices {
            if scattered {
                dots[idx].position = CGPoint(
                    x: CGFloat.random(in: 0...320),
                    y: CGFloat.random(in: 0...400)
                )
            } else {
                dots[idx].position = dots[idx].target
            }
        }
    }
}

#Preview {
    PixelToImageView(imageName: "SVP.jpg")
}
