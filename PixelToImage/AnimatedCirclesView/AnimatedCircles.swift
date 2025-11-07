import UIKit

class CircleAnimationContainerView: UIView {
    
    enum CircleFillStyle {
        case gradient([UIColor])
        case solid(UIColor)
        case white
    }
    
    // Public configurable properties
    var numberOfCircles: Int = 4 {
        didSet { setupCircles() }
    }
    var circleFillStyles: [CircleFillStyle] = [.solid(.red), .solid(.green), .solid(.blue), .solid(.orange)] {
        didSet { updateCircleStyles() }
    }
    var movementSpeed: CGFloat = 100.0 // points per second
    var blurLevel: CGFloat = 10 {
        didSet { blurEffectView?.alpha = min(max(blurLevel / 30.0, 0), 1) }
    }
    
    private var circleViews: [UIView] = []
    private var velocities: [CGPoint] = []
    private var displayLink: CADisplayLink?
    private var blurEffectView: UIVisualEffectView?
    var isAnimating = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        clipsToBounds = true
        setupBlur()
        setupCircles()
    }
    
    private func setupCircles() {
        circleViews.forEach {
            $0.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            $0.removeFromSuperview()
        }
        circleViews.removeAll()
        velocities.removeAll()
        
        for i in 0..<numberOfCircles {
            let circle = UIView()
            circle.frame.size = CGSize(width: 40, height: 40)
            circle.layer.cornerRadius = 20
            circle.layer.masksToBounds = true
            
            addSubview(circle)
            circleViews.append(circle)
            
            // Assign fill style
            applyFillStyle(to: circle, styleIndex: i)
            
            // Random initial velocity direction with speed adjusted to frame rate (60 fps assumed)
            let angle = CGFloat.random(in: 0..<(2 * .pi))
            let velocity = CGPoint(x: cos(angle) * movementSpeed / 60,
                                   y: sin(angle) * movementSpeed / 60)
            velocities.append(velocity)
        }

        setInitialPositions()
    }
    
    private func applyFillStyle(to circle: UIView, styleIndex: Int) {
        guard circleFillStyles.indices.contains(styleIndex) else {
            circle.backgroundColor = .gray
            return
        }
        
        let style = circleFillStyles[styleIndex]
        switch style {
        case .gradient(let colors):
            circle.backgroundColor = .clear
            
            // Remove previous gradient layers if any
            circle.layer.sublayers?.forEach {
                if $0 is CAGradientLayer {
                    $0.removeFromSuperlayer()
                }
            }
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = circle.bounds
            gradientLayer.colors = colors.map { $0.cgColor }
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
            gradientLayer.cornerRadius = circle.layer.cornerRadius
            
            circle.layer.insertSublayer(gradientLayer, at: 0)
            
        case .solid(let color):
            circle.layer.sublayers?.forEach {
                if $0 is CAGradientLayer { $0.removeFromSuperlayer() }
            }
            circle.backgroundColor = color
            
        case .white:
            circle.layer.sublayers?.forEach {
                if $0 is CAGradientLayer { $0.removeFromSuperlayer() }
            }
            circle.backgroundColor = .white
        }
    }
    
    private func updateCircleStyles() {
        for (i, circle) in circleViews.enumerated() {
            applyFillStyle(to: circle, styleIndex: i)
        }
    }
    private var tintOverlayView: UIView?

    private func setupBlur() {
        if blurEffectView == nil {
            let blurEffect = UIBlurEffect(style: .light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = bounds
            blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurView.isUserInteractionEnabled = false
            addSubview(blurView)
            blurEffectView = blurView
            
            // Create a white tint overlay with low opacity on top of blur for water glass effect
                   let tintView = UIView(frame: bounds)
                   tintView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
                   tintView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                   tintView.isUserInteractionEnabled = false
                   blurView.contentView.addSubview(tintView)
                   tintOverlayView = tintView
            
            blurEffectView?.alpha = min(max(blurLevel / 30.0, 0), 1)
        }
        bringSubviewToFront(blurEffectView!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
            blurEffectView?.frame = bounds
            tintOverlayView?.frame = blurEffectView?.contentView.bounds ?? .zero
            ensureCirclesWithinBounds()
    }
    
    private func setInitialPositions() {
        for circle in circleViews {
            if bounds.width == 0 || bounds.height == 0 {
                circle.center = CGPoint(x: Int(arc4random()) % 100, y: Int(arc4random()) % 100)
            }else{
                let radius = circle.bounds.width / 2
                circle.center = CGPoint(
                    x: CGFloat.random(in: radius...(bounds.width - radius)),
                    y: CGFloat.random(in: radius...(bounds.height - radius))
                )
            }
        }
    }
    
    private func ensureCirclesWithinBounds() {
        let radius = circleViews.first?.bounds.width ?? 40 / 2
        for circle in circleViews {
            var center = circle.center
            center.x = min(max(center.x, radius - 20), bounds.width + radius + 10)
            center.y = min(max(center.y, radius - 20), bounds.height + radius + 10)
            circle.center = center
        }
    }
    
    func startAnimation() {
        guard displayLink == nil else { return }
        isAnimating = true
        displayLink = CADisplayLink(target: self, selector: #selector(updatePositions))
        displayLink?.add(to: .main, forMode: .default)
    }
    
    func stopAnimation() {
        isAnimating = false
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func updatePositions() {
        guard isAnimating else { return }
        
        let radius = circleViews.first?.bounds.width ?? 40 / 2
        
        for (index, circle) in circleViews.enumerated() {
            var newCenter = CGPoint(x: circle.center.x + velocities[index].x,
                                    y: circle.center.y + velocities[index].y)
            
            // Bounce horizontally
            if newCenter.x - radius < 0 {
                newCenter.x = radius
                velocities[index].x = -velocities[index].x
            } else if newCenter.x + radius > bounds.width {
                newCenter.x = bounds.width - radius
                velocities[index].x = -velocities[index].x
            }
            
            // Bounce vertically
            if newCenter.y - radius < 0 {
                newCenter.y = radius
                velocities[index].y = -velocities[index].y
            } else if newCenter.y + radius > bounds.height {
                newCenter.y = bounds.height - radius
                velocities[index].y = -velocities[index].y
            }
            
            circle.center = newCenter
        }
    }
}
