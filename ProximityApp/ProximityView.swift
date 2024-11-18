//
//  ProximityView.swift
//  ProximityApp
//
//  Created by Amit Garg on 18/11/24.
//

import UIKit

class ProximityView: UIView {
    
    /// Used to keep track of all the strokes
    internal var stack: [CGPoint] = []
    
    /// This is used to render a user's strokes
    fileprivate let imageView = UIImageView()
    
    var originPoint: CGPoint?
    
    /// Adds the subviews and initializes stack
    private func initialize(_ frame: CGRect) {
        addSubview(imageView)
        draw(frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize(frame)
        backgroundColor = .white
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        addGestureRecognizer(gesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        let point = sender.location(in: self)
        if point.x > 10 &&
            point.x < UIScreen.main.bounds.width - 10 &&
            point.y > 10 &&
            point.y < UIScreen.main.bounds.height - 10 {
            originPoint = point
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        imageView.frame = rect
        guard let originPoint else {
            return
        }
    
        let size = 15.0
        let centerX = originPoint.x - size / 2.0
        let centerY = originPoint.y - size / 2.0
        let path = UIBezierPath(ovalIn: .init(x: centerX, y: centerY, width: size, height: size))
        UIColor.blue.setStroke()
        UIColor.red.setFill()
        path.lineWidth = 3
        path.stroke()
        path.fill()
    }
}

extension ProximityView {

    /// Triggered when touches move
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let originPoint = originPoint else {
            return
        }
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            checkDistanceAndVibrate(originPoint, toPoint: currentPoint)
        }
    }
}

extension ProximityView {

    func checkDistanceAndVibrate(_ originPoint: CGPoint, toPoint: CGPoint) {
        let screenWidth  = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        
        let xDifference  = originPoint.x - toPoint.x
        let yDifference  = originPoint.y - toPoint.y
        
        let absXDifference = abs(xDifference)
        let absYDifference = abs(yDifference)
        
        var result = 0.0
        if absXDifference > absYDifference {
            let differ = screenWidth / 4
            result = absXDifference / differ
        } else {
            let differ = screenHeight / 4
            result = absYDifference / differ
        }
        print(result)
        if result < 0.1 {
            Vibration.success.vibrate()
        } else if result >= 0.1 && result <= 1 {
            Vibration.heavy.vibrate()
        } else if result <= 2 {
            Vibration.medium.vibrate()
        } else if result <= 3 {
            Vibration.light.vibrate()
        } else if result == 4 {
            Vibration.soft.vibrate()
        } else {
            print("------ No vibration found")
        }
    }
 }