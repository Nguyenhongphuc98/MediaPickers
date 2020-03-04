//
//  MPCropControl.swift
//  MediaPicker
//
//  Created by CPU11716 on 3/4/20.
//  Copyright © 2020 CPU11716. All rights reserved.
//

import UIKit

class MPCropControl: UIControl {

    public var didResize: ((_ sender: MPCropControl, _ translation: CGPoint)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpUI()
    }
    
    func setUpUI() {
        backgroundColor = .clear
        isExclusiveTouch = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(userDidPan(gesture:)))
        panGesture.delegate = self
        addGestureRecognizer(panGesture)
        
        let pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(userDidPress(gesture:)))
        pressGesture.minimumPressDuration = 0.1
        pressGesture.delegate = self
        addGestureRecognizer(pressGesture)
    }
    
    @objc func userDidPan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .began:
            print("begin pan")
            
        case .changed:
            let translation = gesture.translation(in: superview)
            
            if let didResize = self.didResize {
                didResize(self, translation)
            }
            
            gesture.setTranslation(CGPoint.zero, in: superview)
            print("begin pan")
            
        case .ended, .cancelled:
            print("pan ended | cancel")
            
        default:
            break;
        }
    }
    
    @objc func userDidPress(gesture: UIPanGestureRecognizer) {
        print("press control")
    }
}

extension MPCropControl: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
