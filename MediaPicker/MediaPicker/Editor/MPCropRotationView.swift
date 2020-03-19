//
//  MPCropRotationView.swift
//  MediaPicker
//
//  Created by CPU11716 on 3/3/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit

let MPCropRotationViewMaxAngleInDegrees: CGFloat = 45
let MPCropRotationViewWheelRadious: CGFloat = 200

class MPCropRotationView: UIControl {

    //angle in radian
    var angle: CGFloat = 0
    
    var angleInDegrees: CGFloat { return 180 * angle / .pi }
    
    let wheelRotationView: UIImageView
    
    let needleRotationView: UIImageView
    
    public var angleDidBeginChanging: (() -> Void)?
    
    public var angleDidChange: ((_ angle: CGFloat) -> Void)?
    
    public var angleDidEndChanging: (() -> Void)?
    
    override init(frame: CGRect) {
        
        wheelRotationView = UIImageView(frame: CGRect(x: 0, y: 0, width: MPCropRotationViewWheelRadious * 2, height: MPCropRotationViewWheelRadious * 2))
        wheelRotationView.image = #imageLiteral(resourceName: "PhotoEditorRotationWheel")
        wheelRotationView.alpha = 1.0
        
        needleRotationView = UIImageView(frame: CGRect(x: frame.size.width/2, y: 47, width: 10, height: 10))
        needleRotationView.image = #imageLiteral(resourceName: "PhotoEditorRotationNeedle")
        needleRotationView.contentMode = .center
        
        super.init(frame: frame)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(userDidPan(gesture:)))
        self.addGestureRecognizer(panGesture)
        
        self.clipsToBounds = true
        addSubview(wheelRotationView)
        addSubview(needleRotationView)
    }
    
    required init?(coder: NSCoder) {
        
        wheelRotationView = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        wheelRotationView.image = #imageLiteral(resourceName: "PhotoEditorRotationWheel")
        wheelRotationView.alpha = 1.0
        
        needleRotationView = UIImageView(frame: CGRect.zero)
        needleRotationView.image = #imageLiteral(resourceName: "PhotoEditorRotationNeedle")
        needleRotationView.contentMode = .center
        
        super.init(coder: coder)
        
        self.clipsToBounds = true
        addSubview(wheelRotationView)
        addSubview(needleRotationView)
    }
    
    private func setAngle(angle: CGFloat) {
        self.angle = angle
        setNeedsLayout()
    }
    
    public func setAngle(angle: CGFloat, isAnimate: Bool) {
        
        if isAnimate {
            
            UIView.animate(withDuration: 1) {
                self.wheelRotationView.transform = CGAffineTransform.identity
            }
            setAngle(angle: angle)
        } else {
            setAngle(angle: angle)
        }
    }
    
    override func layoutSubviews() {
        
        wheelRotationView.center = CGPoint(x: self.frame.size.width / 2, y: -152);
        wheelRotationView.transform = CGAffineTransform.init(rotationAngle: angle)
        
        needleRotationView.frame = CGRect(x: (self.frame.size.width - 10)/2, y: 47, width: 10, height: 10);
        //needleRotationView.transform = CGAffineTransform.identity;
    }
    
    @objc func userDidPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
            
        case .began:
            if let angleBeginChanging = self.angleDidBeginChanging {
                angleBeginChanging()
            }
            
        case .changed:
            
            var translation: CGFloat = 0
            let dx = gesture.translation(in: self).x
            let dy = gesture.translation(in: self).y
            translation = sqrt(pow(dx, 2) + pow(dy, 2))
            translation = (dx > 0) ? translation : -translation
            
            let deltaAngle = 180 * translation / (.pi * MPCropRotationViewWheelRadious)
            let newAngleInDegrees = min(MPCropRotationViewMaxAngleInDegrees, max(-MPCropRotationViewMaxAngleInDegrees, angleInDegrees - deltaAngle))
            
            angle = newAngleInDegrees * .pi / 180
            if let anglechanged = self.angleDidChange {
                anglechanged(angle)
            }
            setNeedsLayout()

            gesture.setTranslation(CGPoint.zero, in: self)
            print("change: \(translation)")
            
        case .ended,.cancelled:
            if let angleEndChanging = self.angleDidEndChanging {
                angleEndChanging()
            }
            
        default:
            break
        }
    }
}
